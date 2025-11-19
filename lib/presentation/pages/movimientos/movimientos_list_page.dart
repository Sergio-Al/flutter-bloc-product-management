import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/movimiento.dart';
import '../../blocs/movimiento/movimiento_bloc.dart';
import '../../blocs/movimiento/movimiento_event.dart';
import '../../blocs/movimiento/movimiento_state.dart';
import 'movimiento_detail_page.dart';
import 'crear_entrada_page.dart';
import 'crear_salida_page.dart';
import 'crear_transferencia_page.dart';

class MovimientosListPage extends StatefulWidget {
  const MovimientosListPage({Key? key}) : super(key: key);

  @override
  State<MovimientosListPage> createState() => _MovimientosListPageState();
}

class _MovimientosListPageState extends State<MovimientosListPage> {
  String _filterType = 'todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMovimientos();
      }
    });
  }

  void _loadMovimientos() {
    switch (_filterType) {
      case 'pendientes':
        context.read<MovimientoBloc>().add(const LoadMovimientosPendientes());
        break;
      case 'enTransito':
        context.read<MovimientoBloc>().add(const LoadMovimientosEnTransito());
        break;
      case 'compras':
        context.read<MovimientoBloc>().add(const LoadMovimientosByTipo('COMPRA'));
        break;
      case 'ventas':
        context.read<MovimientoBloc>().add(const LoadMovimientosByTipo('VENTA'));
        break;
      case 'transferencias':
        context.read<MovimientoBloc>().add(const LoadMovimientosByTipo('TRANSFERENCIA'));
        break;
      case 'ajustes':
        context.read<MovimientoBloc>().add(const LoadMovimientosByTipo('AJUSTE'));
        break;
      default:
        context.read<MovimientoBloc>().add(const LoadMovimientos());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Buscar',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMovimientos,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: BlocConsumer<MovimientoBloc, MovimientoState>(
              listener: (context, state) {
                if (state is MovimientoOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message ?? 'Operación exitosa'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _loadMovimientos();
                }
                if (state is MovimientoError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MovimientoLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MovimientosLoaded) {
                  final movimientos = state.movimientos;

                  if (movimientos.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadMovimientos();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: movimientos.length,
                      itemBuilder: (context, index) {
                        return _buildMovimientoCard(context, movimientos[index]);
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
        onPressed: () => _showCreateMenu(context),
        child: const Icon(Icons.add),
        tooltip: 'Nuevo Movimiento',
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
            label: const Text('Todos'),
            selected: _filterType == 'todos',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'todos');
                _loadMovimientos();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Pendientes'),
            avatar: const Icon(Icons.pending, size: 16),
            selected: _filterType == 'pendientes',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'pendientes');
                _loadMovimientos();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('En Tránsito'),
            avatar: const Icon(Icons.local_shipping, size: 16),
            selected: _filterType == 'enTransito',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'enTransito');
                _loadMovimientos();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Compras'),
            avatar: const Icon(Icons.shopping_cart, size: 16),
            selected: _filterType == 'compras',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'compras');
                _loadMovimientos();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Ventas'),
            avatar: const Icon(Icons.point_of_sale, size: 16),
            selected: _filterType == 'ventas',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'ventas');
                _loadMovimientos();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Transferencias'),
            avatar: const Icon(Icons.swap_horiz, size: 16),
            selected: _filterType == 'transferencias',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'transferencias');
                _loadMovimientos();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Ajustes'),
            avatar: const Icon(Icons.tune, size: 16),
            selected: _filterType == 'ajustes',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'ajustes');
                _loadMovimientos();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMovimientoCard(BuildContext context, Movimiento movimiento) {
    Color statusColor = _getStatusColor(movimiento.estado);
    IconData tipoIcon = _getTipoIcon(movimiento.tipo);
    IconData statusIcon = _getStatusIcon(movimiento.estado);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Icon(tipoIcon, color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                movimiento.numeroMovimiento,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(statusIcon, size: 16, color: statusColor),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.inventory_2, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Cantidad: ${movimiento.cantidad}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.event, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(movimiento.fechaMovimiento),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Text(
                movimiento.estado,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                movimiento.tipo,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            if (movimiento.costoTotal > 0) ...[
              const SizedBox(height: 4),
              Text(
                '\$${movimiento.costoTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        onTap: () => _navigateToDetail(context, movimiento.id),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.move_to_inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay movimientos',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para crear uno',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String estado) {
    switch (estado) {
      case 'PENDIENTE':
        return Colors.orange;
      case 'EN_TRANSITO':
        return Colors.blue;
      case 'COMPLETADO':
        return Colors.green;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo) {
      case 'COMPRA':
        return Icons.shopping_cart;
      case 'VENTA':
        return Icons.point_of_sale;
      case 'TRANSFERENCIA':
        return Icons.swap_horiz;
      case 'AJUSTE':
        return Icons.tune;
      case 'DEVOLUCION':
        return Icons.keyboard_return;
      case 'MERMA':
        return Icons.trending_down;
      default:
        return Icons.move_to_inbox;
    }
  }

  IconData _getStatusIcon(String estado) {
    switch (estado) {
      case 'PENDIENTE':
        return Icons.pending;
      case 'EN_TRANSITO':
        return Icons.local_shipping;
      case 'COMPLETADO':
        return Icons.check_circle;
      case 'CANCELADO':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Buscar Movimiento'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Número de movimiento',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (query) {
            Navigator.pop(dialogContext);
            if (query.isNotEmpty) {
              context.read<MovimientoBloc>().add(LoadMovimientoByNumero(query));
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

  void _showCreateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.blue),
              title: const Text('Entrada (Compra)'),
              subtitle: const Text('Registrar compra de productos'),
              onTap: () {
                Navigator.pop(context);
                _navigateToCreateEntrada(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.point_of_sale, color: Colors.green),
              title: const Text('Salida (Venta/Merma)'),
              subtitle: const Text('Registrar venta o merma'),
              onTap: () {
                Navigator.pop(context);
                _navigateToCreateSalida(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.orange),
              title: const Text('Transferencia'),
              subtitle: const Text('Transferir entre tiendas'),
              onTap: () {
                Navigator.pop(context);
                _navigateToCreateTransferencia(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateEntrada(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<MovimientoBloc>(),
          child: const CrearEntradaPage(),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadMovimientos();
    }
  }

  void _navigateToCreateSalida(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<MovimientoBloc>(),
          child: const CrearSalidaPage(),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadMovimientos();
    }
  }

  void _navigateToCreateTransferencia(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<MovimientoBloc>(),
          child: const CrearTransferenciaPage(),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadMovimientos();
    }
  }

  void _navigateToDetail(BuildContext context, String movimientoId) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<MovimientoBloc>()
            ..add(LoadMovimientoById(movimientoId)),
          child: MovimientoDetailPage(movimientoId: movimientoId),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadMovimientos();
    }
  }
}
