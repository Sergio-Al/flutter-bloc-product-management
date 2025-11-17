import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../blocs/producto/producto_bloc.dart';
import '../../blocs/producto/producto_event.dart';
import '../../blocs/producto/producto_state.dart';
import 'producto_detail_page.dart';
import 'producto_form_page.dart';

class ProductosListPage extends StatelessWidget {
  const ProductosListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductoBloc>()..add(const LoadProductosActivos()),
      child: const _ProductosListView(),
    );
  }
}

class _ProductosListView extends StatelessWidget {
  const _ProductosListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          // Remove sync indicator as it requires SyncService injection
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => _handleFilter(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'todos',
                child: Text('Todos'),
              ),
              const PopupMenuItem(
                value: 'activos',
                child: Text('Solo Activos'),
              ),
              const PopupMenuItem(
                value: 'peligrosos',
                child: Text('Materiales Peligrosos'),
              ),
              const PopupMenuItem(
                value: 'especial',
                child: Text('Almacén Cubierto'),
              ),
              const PopupMenuItem(
                value: 'stock_bajo',
                child: Text('Stock Bajo'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<ProductoBloc, ProductoState>(
        listener: (context, state) {
          if (state is ProductoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is ProductoOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Reload list
            context.read<ProductoBloc>().add(const LoadProductosActivos());
          }
        },
        builder: (context, state) {
          if (state is ProductoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductoEmpty) {
            return _buildEmptyState(context);
          }

          if (state is ProductoLoaded) {
            final productos = state.productos;

            if (productos.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductoBloc>().add(const RefreshProductos());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return _ProductoCard(
                    producto: producto,
                    onTap: () => _navigateToDetail(context, producto.id),
                  );
                },
              ),
            );
          }

          // Initial or unknown state
          return _buildEmptyState(context);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay productos',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer producto usando el botón +',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Buscar Producto'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nombre, código o descripción',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (query) {
            Navigator.of(dialogContext).pop();
            if (query.isNotEmpty) {
              context.read<ProductoBloc>().add(SearchProductos(query: query));
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _handleFilter(BuildContext context, String filter) {
    switch (filter) {
      case 'activos':
        context.read<ProductoBloc>().add(const LoadProductosActivos());
        break;
      case 'peligrosos':
        context.read<ProductoBloc>().add(const LoadProductosPeligrosos());
        break;
      case 'especial':
        context.read<ProductoBloc>().add(const LoadProductosAlmacenamientoEspecial());
        break;
      case 'stock_bajo':
        context.read<ProductoBloc>().add(const LoadProductosStockBajo());
        break;
    }
  }

  void _navigateToDetail(BuildContext context, String productoId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductoDetailPage(productoId: productoId),
      ),
    );
    
    // Reload list if producto was updated or deleted
    if (result == true && context.mounted) {
      context.read<ProductoBloc>().add(const LoadProductosActivos());
    }
  }

  void _navigateToCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<ProductoBloc>(),
          child: const ProductoFormPage(),
        ),
      ),
    );
    
    // Reload list if producto was created
    if (result == true && context.mounted) {
      context.read<ProductoBloc>().add(const LoadProductosActivos());
    }
  }
}

class _ProductoCard extends StatelessWidget {
  final dynamic producto; // Should be Producto entity
  final VoidCallback onTap;

  const _ProductoCard({
    required this.producto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: producto.activo 
              ? Colors.green.shade100 
              : Colors.grey.shade300,
          child: Icon(
            Icons.inventory_2,
            color: producto.activo 
                ? Colors.green.shade700 
                : Colors.grey.shade600,
          ),
        ),
        title: Text(
          producto.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${producto.codigo}'),
            if (producto.descripcion != null)
              Text(
                producto.descripcion!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            Row(
              children: [
                if (producto.materialPeligroso)
                  Container(
                    margin: const EdgeInsets.only(top: 4, right: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PELIGROSO',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (producto.requiereAlmacenCubierto)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'CUBIERTO',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${producto.precioVenta.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Stock: ${producto.stockMinimo}-${producto.stockMaximo}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
