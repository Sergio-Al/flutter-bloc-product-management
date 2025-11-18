import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/proveedor.dart';
import '../../blocs/proveedor/proveedor_bloc.dart';
import '../../blocs/proveedor/proveedor_event.dart';
import '../../blocs/proveedor/proveedor_state.dart';
import 'proveedores_detail_page.dart';
import 'proveedores_form_page.dart';

class ProveedoresListPage extends StatefulWidget {
  const ProveedoresListPage({Key? key}) : super(key: key);

  @override
  State<ProveedoresListPage> createState() => _ProveedoresListPageState();
}

class _ProveedoresListPageState extends State<ProveedoresListPage> {
  String _filterType = 'activos'; // Start with activos filter

  @override
  void initState() {
    super.initState();
    // Load data after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadProveedores();
      }
    });
  }

  void _loadProveedores() {
    if (_filterType == 'activos') {
      context.read<ProveedorBloc>().add(const LoadProveedoresActivos());
    } else if (_filterType == 'credito') {
      context.read<ProveedorBloc>().add(const LoadProveedoresConCredito());
    } else {
      context.read<ProveedorBloc>().add(const LoadProveedores());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Buscar',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProveedores,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: BlocConsumer<ProveedorBloc, ProveedorState>(
              listener: (context, state) {
                if (state is ProveedorOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                if (state is ProveedorError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProveedorLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProveedorLoaded || state is ProveedorOperationSuccess) {
                  final proveedores = state is ProveedorLoaded
                      ? state.proveedores
                      : (state as ProveedorOperationSuccess).proveedores;

                  if (proveedores.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadProveedores();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: proveedores.length,
                      itemBuilder: (context, index) {
                        return _buildProveedorCard(context, proveedores[index]);
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
        tooltip: 'Nuevo Proveedor',
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Activos'),
            selected: _filterType == 'activos',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'activos');
                _loadProveedores();
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
                _loadProveedores();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Con Crédito'),
            selected: _filterType == 'credito',
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'credito');
                _loadProveedores();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProveedorCard(BuildContext context, Proveedor proveedor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: proveedor.activo
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
          child: Text(
            proveedor.razonSocial[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          proveedor.razonSocial,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NIT: ${proveedor.nit}'),
            if (proveedor.ciudad != null) Text('📍 ${proveedor.ciudad}'),
            Text(
              proveedor.paymentTerms,
              style: TextStyle(
                color: proveedor.offersCredit ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Icon(
          proveedor.activo ? Icons.check_circle : Icons.cancel,
          color: proveedor.activo ? Colors.green : Colors.red,
        ),
        onTap: () => _navigateToDetail(context, proveedor.id),
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
            'No hay proveedores',
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

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Buscar Proveedor'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Nombre, NIT o Razón Social',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (query) {
            Navigator.pop(dialogContext);
            if (query.isNotEmpty) {
              context.read<ProveedorBloc>().add(SearchProveedores(query));
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
          create: (context) => getIt<ProveedorBloc>(),
          child: const ProveedoresFormPage(),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadProveedores();
    }
  }

  void _navigateToDetail(BuildContext context, String proveedorId) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<ProveedorBloc>()
            ..add(LoadProveedorById(proveedorId)),
          child: ProveedorDetailPage(proveedorId: proveedorId),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadProveedores();
    }
  }
}
