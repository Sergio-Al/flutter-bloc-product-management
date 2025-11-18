import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../blocs/tienda/tienda_bloc.dart';
import '../../blocs/tienda/tienda_event.dart';
import '../../blocs/tienda/tienda_state.dart';
import 'tienda_detail_page.dart';
import 'tienda_form_page.dart';

class TiendasListPage extends StatelessWidget {
  const TiendasListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TiendaBloc>()..add(const LoadTiendasActivas()),
      child: const _TiendasListView(),
    );
  }
}

class _TiendasListView extends StatelessWidget {
  const _TiendasListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiendas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => _handleFilter(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'todos', child: Text('Todas')),
              const PopupMenuItem(value: 'activos', child: Text('Solo Activas')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TiendaBloc>().add(const RefreshTiendas()),
          ),
        ],
      ),
      body: BlocConsumer<TiendaBloc, TiendaState>(
        listener: (context, state) {
          if (state is TiendaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is TiendaOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            context.read<TiendaBloc>().add(const LoadTiendasActivas());
          }
        },
        builder: (context, state) {
          if (state is TiendaLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TiendaLoaded) {
            if (state.tiendas.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TiendaBloc>().add(const RefreshTiendas());
                await context.read<TiendaBloc>().stream.firstWhere((s) => s is! TiendaLoading);
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.tiendas.length,
                itemBuilder: (context, index) {
                  final tienda = state.tiendas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: tienda.activo ? Colors.blue : Colors.grey,
                        child: Text(
                          tienda.nombre[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(tienda.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${tienda.codigo}'),
                          Text('${tienda.ciudad}, ${tienda.departamento}'),
                        ],
                      ),
                      trailing: Icon(
                        tienda.activo ? Icons.check_circle : Icons.cancel,
                        color: tienda.activo ? Colors.green : Colors.red,
                      ),
                      onTap: () => _navigateToDetail(context, tienda.id),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Estado desconocido'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tienda'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No hay tiendas'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToCreate(context),
            icon: const Icon(Icons.add),
            label: const Text('Crear Tienda'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    String query = '';
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Buscar Tienda'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nombre o código'),
          onChanged: (v) => query = v,
          onSubmitted: (v) {
            if (v.isNotEmpty) {
              Navigator.pop(dialogContext);
              context.read<TiendaBloc>().add(SearchTiendas(query: v));
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (query.isNotEmpty) {
                Navigator.pop(dialogContext);
                context.read<TiendaBloc>().add(SearchTiendas(query: query));
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
      'todos': const LoadTiendas(),
      'activos': const LoadTiendasActivas(),
    };
    context.read<TiendaBloc>().add(events[filter]!);
  }

  void _navigateToDetail(BuildContext context, String id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<TiendaBloc>()..add(LoadTiendaById(id: id)),
          child: TiendaDetailPage(tiendaId: id),
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<TiendaBloc>().add(const LoadTiendasActivas());
    }
  }

  void _navigateToCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<TiendaBloc>(),
          child: const TiendaFormPage(),
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<TiendaBloc>().add(const LoadTiendasActivas());
    }
  }
}
