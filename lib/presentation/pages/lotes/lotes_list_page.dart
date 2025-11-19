import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/lote.dart';
import '../../blocs/lote/lote_bloc.dart';
import '../../blocs/lote/lote_event.dart';
import '../../blocs/lote/lote_state.dart';
import 'lotes_detail_page.dart';
import 'lotes_form_page.dart';

class LotesListPage extends StatefulWidget {
  const LotesListPage({Key? key}) : super(key: key);

  @override
  State<LotesListPage> createState() => _LotesListPageState();
}

class _LotesListPageState extends State<LotesListPage> {
  String _filterType = 'conStock'; // Start with stock filter

  @override
  void initState() {
    super.initState();
    // Load data after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadLotes();
      }
    });
  }

  void _loadLotes() {
    switch (_filterType) {
      case 'conStock':
        context.read<LoteBloc>().add(const LoadLotesConStock());
        break;
      case 'vencidos':
        context.read<LoteBloc>().add(const LoadLotesVencidos());
        break;
      case 'porVencer':
        context.read<LoteBloc>().add(const LoadLotesPorVencer());
        break;
      case 'vacios':
        context.read<LoteBloc>().add(const LoadLotesVacios());
        break;
      case 'conCertificado':
        context.read<LoteBloc>().add(const LoadLotesConCertificado());
        break;
      default:
        context.read<LoteBloc>().add(const LoadLotes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lotes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Buscar',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLotes,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: BlocConsumer<LoteBloc, LoteState>(
              listener: (context, state) {
                if (state is LoteOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                if (state is LoteError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is LoteLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is LoteLoaded || state is LoteOperationSuccess) {
                  final lotes = state is LoteLoaded
                      ? state.lotes
                      : (state as LoteOperationSuccess).lotes;

                  if (lotes.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadLotes();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: lotes.length,
                      itemBuilder: (context, index) {
                        return _buildLoteCard(context, lotes[index]);
                      },
                    ),
                  );
                }

                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreate(context),
        child: const Icon(Icons.add),
        tooltip: 'Nuevo Lote',
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Con Stock'),
            selected: _filterType == 'conStock',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'conStock');
                _loadLotes();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Todos'),
            selected: _filterType == 'todos',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'todos');
                _loadLotes();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Por Vencer'),
            selected: _filterType == 'porVencer',
            avatar: const Icon(Icons.warning, size: 16),
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'porVencer');
                _loadLotes();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Vencidos'),
            selected: _filterType == 'vencidos',
            avatar: const Icon(Icons.error, size: 16),
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'vencidos');
                _loadLotes();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Vacíos'),
            selected: _filterType == 'vacios',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'vacios');
                _loadLotes();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Con Certificado'),
            selected: _filterType == 'conCertificado',
            avatar: const Icon(Icons.verified, size: 16),
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'conCertificado');
                _loadLotes();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoteCard(BuildContext context, Lote lote) {
    Color statusColor = Colors.green;
    IconData statusIcon = Icons.check_circle;
    String statusText = 'Disponible';

    if (lote.isExpired) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'Vencido';
    } else if (lote.isNearExpiration) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
      statusText = 'Por vencer';
    } else if (lote.isEmpty) {
      statusColor = Colors.grey;
      statusIcon = Icons.inventory_2;
      statusText = 'Vacío';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Icon(statusIcon, color: Colors.white),
        ),
        title: Text(
          lote.numeroLote,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock: ${lote.cantidadActual}/${lote.cantidadInicial}'),
            if (lote.fechaVencimiento != null)
              Text(
                'Vence: ${_formatDate(lote.fechaVencimiento!)}',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            LinearProgressIndicator(
              value: lote.cantidadInicial > 0
                  ? lote.cantidadActual / lote.cantidadInicial
                  : 0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (lote.hasCertificate)
              const Icon(
                Icons.verified,
                size: 16,
                color: Colors.blue,
              ),
          ],
        ),
        onTap: () => _navigateToDetail(context, lote.id),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay lotes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar uno',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Buscar Lote'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Número de lote o factura',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (query) {
            Navigator.pop(dialogContext);
            if (query.isNotEmpty) {
              context.read<LoteBloc>().add(SearchLotes(query));
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _navigateToCreate(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<LoteBloc>(),
          child: const LotesFormPage(),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadLotes();
    }
  }

  void _navigateToDetail(BuildContext context, String loteId) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<LoteBloc>()
            ..add(LoadLoteById(loteId)),
          child: LoteDetailPage(loteId: loteId),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadLotes();
    }
  }
}
