import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/permissions/permission_helper.dart';
import '../../../domain/entities/inventario.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/inventario/inventario_bloc.dart';
import '../../blocs/inventario/inventario_event.dart';
import '../../blocs/inventario/inventario_state.dart';
import 'inventario_detail_page.dart';
import 'inventario_form_page.dart';

class InventariosListPage extends StatefulWidget {
  const InventariosListPage({Key? key}) : super(key: key);

  @override
  State<InventariosListPage> createState() => _InventariosListPageState();
}

class _InventariosListPageState extends State<InventariosListPage> {
  String _filterType = 'disponibles';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInventarios();
      }
    });
  }

  void _loadInventarios() {
    switch (_filterType) {
      case 'disponibles':
        context.read<InventarioBloc>().add(const LoadInventariosDisponibles());
        break;
      case 'stockBajo':
        context.read<InventarioBloc>().add(const LoadInventariosStockBajo());
        break;
      case 'todos':
      default:
        context.read<InventarioBloc>().add(const LoadInventarios());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filtros',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInventarios,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: BlocConsumer<InventarioBloc, InventarioState>(
              listener: (context, state) {
                if (state is InventarioOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message ?? 'Operación exitosa'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _loadInventarios();
                }
                if (state is InventarioError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is InventarioLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is InventariosLoaded) {
                  final inventarios = state.inventarios;

                  if (inventarios.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadInventarios();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: inventarios.length,
                      itemBuilder: (context, index) {
                        return _buildInventarioCard(context, inventarios[index]);
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
      floatingActionButton: _buildFAB(context),
    );
  }

  /// Build FAB with permission check
  /// Create: Gerente and Almacenero can create inventario
  Widget _buildFAB(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.rolNombre;
    }

    // Only show FAB if user can create inventario (Gerente and Almacenero)
    if (!PermissionHelper.canCreateInventario(userRole)) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      onPressed: () => _navigateToCreate(context),
      tooltip: 'Nuevo Inventario',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Disponibles'),
            selected: _filterType == 'disponibles',
            avatar: const Icon(Icons.check_circle, size: 16),
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'disponibles');
                _loadInventarios();
              }
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Stock Bajo'),
            selected: _filterType == 'stockBajo',
            avatar: const Icon(Icons.warning, size: 16),
            onSelected: (selected) {
              if (selected) {
                setState(() => _filterType = 'stockBajo');
                _loadInventarios();
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
                _loadInventarios();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInventarioCard(BuildContext context, Inventario inventario) {
    Color statusColor = Colors.green;
    IconData statusIcon = Icons.check_circle;
    String statusText = 'Disponible';

    if (inventario.isEmpty) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'Vacío';
    } else if (inventario.cantidadDisponible < (inventario.cantidadActual * 0.2)) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
      statusText = 'Stock bajo';
    } else if (inventario.isFullyReserved) {
      statusColor = Colors.blue;
      statusIcon = Icons.lock;
      statusText = 'Reservado';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Icon(statusIcon, color: Colors.white),
        ),
        title: Text(
          'Ubicación: ${inventario.ubicacionFisica ?? "Sin ubicación"}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock actual: ${inventario.cantidadActual}'),
            Text('Disponible: ${inventario.cantidadDisponible}'),
            Text('Reservado: ${inventario.cantidadReservada}'),
            if (inventario.cantidadReservada > 0)
              LinearProgressIndicator(
                value: inventario.reservationPercentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
            const SizedBox(height: 4),
            Text(
              '\$${inventario.valorTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        onTap: () => _navigateToDetail(context, inventario.id),
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
            'No hay inventario',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Filtrar por'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Disponibles'),
              onTap: () {
                Navigator.pop(dialogContext);
                setState(() => _filterType = 'disponibles');
                _loadInventarios();
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Stock bajo'),
              onTap: () {
                Navigator.pop(dialogContext);
                setState(() => _filterType = 'stockBajo');
                _loadInventarios();
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Todos'),
              onTap: () {
                Navigator.pop(dialogContext);
                setState(() => _filterType = 'todos');
                _loadInventarios();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
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
          create: (context) => getIt<InventarioBloc>(),
          child: const InventarioFormPage(),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadInventarios();
    }
  }

  void _navigateToDetail(BuildContext context, String inventarioId) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<InventarioBloc>()
            ..add(LoadInventarioById(inventarioId)),
          child: InventarioDetailPage(inventarioId: inventarioId),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadInventarios();
    }
  }
}
