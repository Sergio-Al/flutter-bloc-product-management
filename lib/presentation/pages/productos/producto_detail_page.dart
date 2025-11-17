import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../blocs/producto/producto_bloc.dart';
import '../../blocs/producto/producto_event.dart';
import '../../blocs/producto/producto_state.dart';
import 'producto_form_page.dart';

class ProductoDetailPage extends StatelessWidget {
  final String productoId;

  const ProductoDetailPage({
    Key? key,
    required this.productoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductoBloc>()
        ..add(LoadProductoById(id: productoId)),
      child: const _ProductoDetailView(),
    );
  }
}

class _ProductoDetailView extends StatefulWidget {
  const _ProductoDetailView();

  @override
  State<_ProductoDetailView> createState() => _ProductoDetailViewState();
}

class _ProductoDetailViewState extends State<_ProductoDetailView> {
  bool _wasModified = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default pop behavior
      onPopInvoked: (didPop) async {
        if (!didPop) {
          // Manually pop with the _wasModified flag
          Navigator.of(context).pop(_wasModified);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle del Producto'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_wasModified);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEdit(context),
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
              tooltip: 'Eliminar',
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
                ),
              );
            }
            if (state is ProductoOperationSuccess) {
              // Return true to indicate the producto was modified (deleted)
              Navigator.of(context).pop(true); // Return to list with success flag
            }
          },
        builder: (context, state) {
          if (state is ProductoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductoDetailLoaded) {
            final producto = state.producto;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2,
                                size: 48,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      producto.nombre,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Código: ${producto.codigo}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: producto.activo
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  producto.activo ? 'ACTIVO' : 'INACTIVO',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Details Sections
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        if (producto.descripcion != null) ...[
                          _buildSectionTitle(context, 'Descripción'),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(producto.descripcion!),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Pricing
                        _buildSectionTitle(context, 'Precios'),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  'Precio de Compra',
                                  '\$${producto.precioCompra.toStringAsFixed(2)}',
                                ),
                                const Divider(),
                                _buildDetailRow(
                                  'Precio de Venta',
                                  '\$${producto.precioVenta.toStringAsFixed(2)}',
                                ),
                                const Divider(),
                                _buildDetailRow(
                                  'Margen de Ganancia',
                                  '${producto.margenGanancia.toStringAsFixed(2)}%',
                                  valueColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Stock
                        _buildSectionTitle(context, 'Control de Stock'),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  'Stock Mínimo',
                                  '${producto.stockMinimo} unidades',
                                ),
                                const Divider(),
                                _buildDetailRow(
                                  'Stock Máximo',
                                  '${producto.stockMaximo} unidades',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Physical Properties
                        if (producto.pesoUnitarioKg != null ||
                            producto.volumenUnitarioM3 != null) ...[
                          _buildSectionTitle(context, 'Propiedades Físicas'),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  if (producto.pesoUnitarioKg != null)
                                    _buildDetailRow(
                                      'Peso Unitario',
                                      '${producto.pesoUnitarioKg} kg',
                                    ),
                                  if (producto.pesoUnitarioKg != null &&
                                      producto.volumenUnitarioM3 != null)
                                    const Divider(),
                                  if (producto.volumenUnitarioM3 != null)
                                    _buildDetailRow(
                                      'Volumen Unitario',
                                      '${producto.volumenUnitarioM3} m³',
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Special Requirements
                        _buildSectionTitle(context, 'Requisitos Especiales'),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildSwitchRow(
                                  'Material Peligroso',
                                  producto.materialPeligroso,
                                  Icons.warning,
                                  Colors.red,
                                ),
                                const Divider(),
                                _buildSwitchRow(
                                  'Requiere Almacén Cubierto',
                                  producto.requiereAlmacenCubierto,
                                  Icons.warehouse,
                                  Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Additional Info
                        if (producto.marca != null ||
                            producto.gradoCalidad != null ||
                            producto.normaTecnica != null) ...[
                          _buildSectionTitle(context, 'Información Adicional'),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  if (producto.marca != null)
                                    _buildDetailRow('Marca', producto.marca!),
                                  if (producto.marca != null &&
                                      (producto.gradoCalidad != null ||
                                          producto.normaTecnica != null))
                                    const Divider(),
                                  if (producto.gradoCalidad != null)
                                    _buildDetailRow(
                                      'Grado de Calidad',
                                      producto.gradoCalidad!,
                                    ),
                                  if (producto.gradoCalidad != null &&
                                      producto.normaTecnica != null)
                                    const Divider(),
                                  if (producto.normaTecnica != null)
                                    _buildDetailRow(
                                      'Norma Técnica',
                                      producto.normaTecnica!,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Timestamps
                        _buildSectionTitle(context, 'Información del Sistema'),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  'Creado',
                                  _formatDate(producto.createdAt),
                                ),
                                const Divider(),
                                _buildDetailRow(
                                  'Última Actualización',
                                  _formatDate(producto.updatedAt),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No se pudo cargar el producto'),
          );
        },
      ),
    ),  // Close PopScope
    );  // Close Scaffold
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(
    String label,
    bool value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: value ? color : Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.grey,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToEdit(BuildContext context) async {
    final state = context.read<ProductoBloc>().state;
    if (state is ProductoDetailLoaded) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProductoBloc>(),
            child: ProductoFormPage(producto: state.producto),
          ),
        ),
      );

      // If producto was updated, reload the detail and mark as modified
      if (result == true && context.mounted) {
        setState(() {
          _wasModified = true;
        });
        context.read<ProductoBloc>().add(
          LoadProductoById(id: state.producto.id),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context) {
    final state = context.read<ProductoBloc>().state;
    if (state is ProductoDetailLoaded) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Eliminar Producto'),
          content: Text(
            '¿Estás seguro que deseas eliminar "${state.producto.nombre}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ProductoBloc>().add(
                      DeleteProducto(id: state.producto.id),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );
    }
  }
}
