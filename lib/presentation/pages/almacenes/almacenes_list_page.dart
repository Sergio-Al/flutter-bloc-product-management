import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/permissions/permission_helper.dart';
import '../../blocs/almacen/almacen_bloc.dart';
import '../../blocs/almacen/almacen_event.dart';
import '../../blocs/almacen/almacen_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import 'almacen_detail_page.dart';
import 'almacen_form_page.dart';

class AlmacenesListPage extends StatelessWidget {
  const AlmacenesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AlmacenBloc>()..add(const LoadAlmacenesActivos()),
      child: const _AlmacenesListView(),
    );
  }
}

class _AlmacenesListView extends StatelessWidget {
  const _AlmacenesListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almacenes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => _handleFilter(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'todos', child: Text('Todos')),
              const PopupMenuItem(value: 'activos', child: Text('Solo Activos')),
              const PopupMenuItem(value: 'principal', child: Text('Principal')),
              const PopupMenuItem(value: 'obra', child: Text('Obra')),
              const PopupMenuItem(value: 'transito', child: Text('Tránsito')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AlmacenBloc>().add(const RefreshAlmacenes()),
          ),
        ],
      ),
      body: BlocConsumer<AlmacenBloc, AlmacenState>(
        listener: (context, state) {
          if (state is AlmacenError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is AlmacenOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());
          }
        },
        builder: (context, state) {
          if (state is AlmacenLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlmacenEmpty) {
            return _buildEmptyState(context);
          }

          if (state is AlmacenLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AlmacenBloc>().add(const RefreshAlmacenes());
                await context.read<AlmacenBloc>().stream.firstWhere((s) => s is! AlmacenLoading);
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.almacenes.length,
                itemBuilder: (context, index) {
                  final almacen = state.almacenes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(_getTipoIcon(almacen.tipo), color: _getTipoColor(almacen.tipo)),
                      title: Text(almacen.nombre),
                      subtitle: Text('${almacen.codigo} - ${almacen.tipo}'),
                      trailing: Icon(almacen.activo ? Icons.check_circle : Icons.cancel, 
                        color: almacen.activo ? Colors.green : Colors.red),
                      onTap: () => _navigateToDetail(context, almacen.id),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Estado desconocido'));
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warehouse_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No hay almacenes'),
          const SizedBox(height: 24),
          _buildCreateButton(context),
        ],
      ),
    );
  }

  Color _getTipoColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'principal': return Colors.blue;
      case 'obra': return Colors.orange;
      default: return Colors.purple;
    }
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'principal': return Icons.home_work;
      case 'obra': return Icons.construction;
      default: return Icons.local_shipping;
    }
  }

  void _showSearchDialog(BuildContext context) {
    String query = '';
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Buscar Almacén'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nombre, código o ubicación'),
          onChanged: (v) => query = v,
          onSubmitted: (v) {
            if (v.isNotEmpty) {
              Navigator.pop(dialogContext);
              context.read<AlmacenBloc>().add(SearchAlmacenes(query: v));
            }
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (query.isNotEmpty) {
                Navigator.pop(dialogContext);
                context.read<AlmacenBloc>().add(SearchAlmacenes(query: query));
              }
            },
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
  }

  void _handleFilter(BuildContext context, String filter) {
    final events = {
      'todos': const LoadAlmacenes(),
      'activos': const LoadAlmacenesActivos(),
      'principal': const LoadAlmacenesByTipo(tipo: 'Principal'),
      'obra': const LoadAlmacenesByTipo(tipo: 'Obra'),
      'transito': const LoadAlmacenesByTipo(tipo: 'Transito'),
    };
    context.read<AlmacenBloc>().add(events[filter]!);
  }

  void _navigateToDetail(BuildContext context, String id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<AlmacenBloc>()..add(LoadAlmacenById(id: id)),
          child: AlmacenDetailPage(almacenId: id),
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());
    }
  }

  void _navigateToCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<AlmacenBloc>(),
          child: const AlmacenFormPage(),
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());
    }
  }

  /// Build FAB with permission check
  /// Only Gerente can create almacenes
  Widget _buildFAB(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.rolNombre;
    }

    // Only show FAB if user can create almacenes (Gerente only)
    if (!PermissionHelper.canCreateAlmacen(userRole)) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: () => _navigateToCreate(context),
      icon: const Icon(Icons.add),
      label: const Text('Nuevo Almacén'),
    );
  }

  /// Build create button for empty state with permission check
  Widget _buildCreateButton(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.rolNombre;
    }

    // Only show create button if user can create almacenes
    if (!PermissionHelper.canCreateAlmacen(userRole)) {
      return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      onPressed: () => _navigateToCreate(context),
      icon: const Icon(Icons.add),
      label: const Text('Crear Almacén'),
    );
  }
}
