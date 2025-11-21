import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../blocs/producto/producto_bloc.dart';
import '../../blocs/producto/producto_event.dart';
import '../../blocs/producto/producto_state.dart';
import 'producto_detail_page.dart';
import 'producto_form_page.dart';

// Filter options model
enum ProductoFilter {
  todos('Todos', Icons.grid_view),
  activos('Solo Activos', Icons.check_circle_outline),
  peligrosos('Materiales Peligrosos', Icons.warning_amber),
  especial('Almacén Cubierto', Icons.warehouse),
  stockBajo('Stock Bajo', Icons.inventory);

  final String label;
  final IconData icon;
  const ProductoFilter(this.label, this.icon);
}

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

class _ProductosListView extends StatefulWidget {
  const _ProductosListView();

  @override
  State<_ProductosListView> createState() => _ProductosListViewState();
}

class _ProductosListViewState extends State<_ProductosListView> {
  ProductoFilter _currentFilter = ProductoFilter.activos;
  bool _isGridView = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilterChips(context),
          Expanded(child: _buildProductList(context)),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Productos'),
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          onPressed: () => setState(() => _isGridView = !_isGridView),
          tooltip: _isGridView ? 'Vista de lista' : 'Vista de cuadrícula',
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortOptions(context),
          tooltip: 'Ordenar',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: Icon(Icons.download),
                title: Text('Exportar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'import',
              child: ListTile(
                leading: Icon(Icons.upload),
                title: Text('Importar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, código o descripción...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ProductoBloc>().add(const LoadProductosActivos());
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.isEmpty) {
            context.read<ProductoBloc>().add(const LoadProductosActivos());
          }
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            context.read<ProductoBloc>().add(SearchProductos(query: value));
          }
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ProductoFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = ProductoFilter.values[index];
          final isSelected = _currentFilter == filter;

          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  filter.icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 6),
                Text(filter.label),
              ],
            ),
            selectedColor: Theme.of(context).primaryColor,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (selected) {
              setState(() => _currentFilter = filter);
              _applyFilter(context, filter);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return BlocConsumer<ProductoBloc, ProductoState>(
      listener: (context, state) {
        if (state is ProductoError) {
          _showErrorSnackbar(context, state.message);
        }
        if (state is ProductoOperationSuccess) {
          _showSuccessSnackbar(context, state.message);
          context.read<ProductoBloc>().add(const LoadProductosActivos());
        }
      },
      builder: (context, state) {
        if (state is ProductoLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductoEmpty || 
            (state is ProductoLoaded && state.productos.isEmpty)) {
          return _buildEmptyState(context);
        }

        if (state is ProductoLoaded) {
          return RefreshIndicator(
            onRefresh: () => _refreshProductos(context),
            child: _isGridView
                ? _buildGridView(context, state.productos)
                : _buildListView(context, state.productos),
          );
        }

        return _buildEmptyState(context);
      },
    );
  }

  Widget _buildListView(BuildContext context, List<dynamic> productos) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: productos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _ProductoListCard(
          producto: productos[index],
          onTap: () => _navigateToDetail(context, productos[index].id),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<dynamic> productos) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        return _ProductoGridCard(
          producto: productos[index],
          onTap: () => _navigateToDetail(context, productos[index].id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay productos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Comienza agregando tu primer producto\nusando el botón (+) abajo',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToCreate(context),
              icon: const Icon(Icons.add),
              label: const Text('Crear Producto'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToCreate(context),
      icon: const Icon(Icons.add),
      label: const Text('Nuevo'),
      elevation: 4,
    );
  }

  // Actions
  void _applyFilter(BuildContext context, ProductoFilter filter) {
    switch (filter) {
      case ProductoFilter.todos:
        context.read<ProductoBloc>().add(const LoadProductosActivos());
        break;
      case ProductoFilter.activos:
        context.read<ProductoBloc>().add(const LoadProductosActivos());
        break;
      case ProductoFilter.peligrosos:
        context.read<ProductoBloc>().add(const LoadProductosPeligrosos());
        break;
      case ProductoFilter.especial:
        context.read<ProductoBloc>().add(const LoadProductosAlmacenamientoEspecial());
        break;
      case ProductoFilter.stockBajo:
        context.read<ProductoBloc>().add(const LoadProductosStockBajo());
        break;
    }
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Ordenar por',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 24),
          _SortOption(
            icon: Icons.sort_by_alpha,
            title: 'Nombre (A-Z)',
            onTap: () => Navigator.pop(context),
          ),
          _SortOption(
            icon: Icons.numbers,
            title: 'Código',
            onTap: () => Navigator.pop(context),
          ),
          _SortOption(
            icon: Icons.attach_money,
            title: 'Precio',
            onTap: () => Navigator.pop(context),
          ),
          _SortOption(
            icon: Icons.inventory,
            title: 'Stock',
            onTap: () => Navigator.pop(context),
          ),
          _SortOption(
            icon: Icons.date_range,
            title: 'Fecha de creación',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'export':
        _showSnackbar(context, 'Exportar funcionalidad próximamente');
        break;
      case 'import':
        _showSnackbar(context, 'Importar funcionalidad próximamente');
        break;
      case 'settings':
        _showSnackbar(context, 'Configuración próximamente');
        break;
    }
  }

  Future<void> _refreshProductos(BuildContext context) async {
    context.read<ProductoBloc>().add(const RefreshProductos());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToDetail(BuildContext context, String productoId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductoDetailPage(productoId: productoId),
      ),
    );

    if (result == true && mounted) {
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

    if (result == true && mounted) {
      context.read<ProductoBloc>().add(const LoadProductosActivos());
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Sort option widget
class _SortOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SortOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// List view card
class _ProductoListCard extends StatelessWidget {
  final dynamic producto;
  final VoidCallback onTap;

  const _ProductoListCard({
    required this.producto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildLeadingAvatar(context),
              const SizedBox(width: 12),
              Expanded(child: _buildMainContent(context)),
              const SizedBox(width: 12),
              _buildTrailingInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingAvatar(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: producto.activo
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.inventory_2,
        color: producto.activo
            ? Theme.of(context).primaryColor
            : Colors.grey.shade600,
        size: 28,
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          producto.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'Código: ${producto.codigo}',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        if (producto.descripcion != null) ...[
          const SizedBox(height: 4),
          Text(
            producto.descripcion!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            if (!producto.activo) _buildStatusChip('INACTIVO', Colors.grey),
            if (producto.materialPeligroso)
              _buildStatusChip('PELIGROSO', Colors.red),
            if (producto.requiereAlmacenCubierto)
              _buildStatusChip('CUBIERTO', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildTrailingInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${producto.precioVenta.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Stock: ${producto.stockMinimo}-${producto.stockMaximo}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Grid view card
class _ProductoGridCard extends StatelessWidget {
  final dynamic producto;
  final VoidCallback onTap;

  const _ProductoGridCard({
    required this.producto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: _buildContent(context)),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: producto.activo
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Center(
        child: Icon(
          Icons.inventory_2,
          size: 48,
          color: producto.activo
              ? Theme.of(context).primaryColor
              : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            producto.nombre,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            producto.codigo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              if (!producto.activo)
                _buildMiniChip(Icons.block, Colors.grey),
              if (producto.materialPeligroso)
                _buildMiniChip(Icons.warning, Colors.red),
              if (producto.requiereAlmacenCubierto)
                _buildMiniChip(Icons.warehouse, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${producto.precioVenta.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              '${producto.stockMinimo}-${producto.stockMaximo}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}
