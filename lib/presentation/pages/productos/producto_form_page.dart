import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/producto.dart';
import '../../blocs/producto/producto_bloc.dart';
import '../../blocs/producto/producto_event.dart';
import '../../blocs/producto/producto_state.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/datasources/local/database/app_database.dart';

class ProductoFormPage extends StatefulWidget {
  final Producto? producto; // null = create, not null = edit

  const ProductoFormPage({Key? key, this.producto}) : super(key: key);

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();

}

class _ProductoFormPageState extends State<ProductoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _codigoController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _precioCompraController;
  late final TextEditingController _precioVentaController;
  late final TextEditingController _stockMinimoController;
  late final TextEditingController _stockMaximoController;
  late final TextEditingController _pesoController;
  late final TextEditingController _volumenController;
  late final TextEditingController _marcaController;
  late final TextEditingController _gradoCalidadController;
  late final TextEditingController _normaTecnicaController;

  late bool _requiereAlmacenCubierto;
  late bool _materialPeligroso;
  late bool _activo;

  // IDs for foreign keys
  String? _categoriaId;
  String? _unidadMedidaId;

  bool get _isEditing => widget.producto != null;

  @override
  void initState() {
    super.initState();
    final producto = widget.producto;

    // Load default IDs from database
    _loadDefaultIds();

    _nombreController = TextEditingController(text: producto?.nombre);
    _codigoController = TextEditingController(text: producto?.codigo);
    _descripcionController = TextEditingController(text: producto?.descripcion);
    _precioCompraController = TextEditingController(
      text: producto?.precioCompra.toString() ?? '0',
    );
    _precioVentaController = TextEditingController(
      text: producto?.precioVenta.toString() ?? '0',
    );
    _stockMinimoController = TextEditingController(
      text: producto?.stockMinimo.toString() ?? '0',
    );
    _stockMaximoController = TextEditingController(
      text: producto?.stockMaximo.toString() ?? '100',
    );
    _pesoController = TextEditingController(
      text: producto?.pesoUnitarioKg?.toString(),
    );
    _volumenController = TextEditingController(
      text: producto?.volumenUnitarioM3?.toString(),
    );
    _marcaController = TextEditingController(text: producto?.marca);
    _gradoCalidadController = TextEditingController(
      text: producto?.gradoCalidad,
    );
    _normaTecnicaController = TextEditingController(
      text: producto?.normaTecnica,
    );

    _requiereAlmacenCubierto = producto?.requiereAlmacenCubierto ?? false;
    _materialPeligroso = producto?.materialPeligroso ?? false;
    _activo = producto?.activo ?? true;
  }

  /// Load default category and unit IDs from database
  Future<void> _loadDefaultIds() async {
    try {
      final db = getIt<AppDatabase>();
      
      // Get first available category
      final categorias = await db.select(db.categorias).get();
      if (categorias.isNotEmpty) {
        setState(() {
          _categoriaId = widget.producto?.categoriaId ?? categorias.first.id;
        });
      }
      
      // Get first available unit
      final unidades = await db.select(db.unidadesMedida).get();
      if (unidades.isNotEmpty) {
        setState(() {
          _unidadMedidaId = widget.producto?.unidadMedidaId ?? unidades.first.id;
        });
      }
    } catch (e) {
      debugPrint('Error loading default IDs: $e');
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoController.dispose();
    _descripcionController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _stockMinimoController.dispose();
    _stockMaximoController.dispose();
    _pesoController.dispose();
    _volumenController.dispose();
    _marcaController.dispose();
    _gradoCalidadController.dispose();
    _normaTecnicaController.dispose();
    super.dispose();
  }


  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validate that required foreign keys are loaded
      if (_categoriaId == null || _unidadMedidaId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Categoría o unidad de medida no disponible'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final now = DateTime.now();

      final producto = Producto(
        id: widget.producto?.id ?? const Uuid().v4(),
        nombre: _nombreController.text.trim(),
        codigo: _codigoController.text.trim(),
        descripcion: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
        categoriaId: _categoriaId!,
        unidadMedidaId: _unidadMedidaId!,
        proveedorPrincipalId: null, // TODO: Optional select
        precioCompra: double.parse(_precioCompraController.text),
        precioVenta: double.parse(_precioVentaController.text),
        pesoUnitarioKg: _pesoController.text.isEmpty
            ? null
            : double.parse(_pesoController.text),
        volumenUnitarioM3: _volumenController.text.isEmpty
            ? null
            : double.parse(_volumenController.text),
        stockMinimo: int.parse(_stockMinimoController.text),
        stockMaximo: int.parse(_stockMaximoController.text),
        marca: _marcaController.text.trim().isEmpty
            ? null
            : _marcaController.text.trim(),
        gradoCalidad: _gradoCalidadController.text.trim().isEmpty
            ? null
            : _gradoCalidadController.text.trim(),
        normaTecnica: _normaTecnicaController.text.trim().isEmpty
            ? null
            : _normaTecnicaController.text.trim(),
        requiereAlmacenCubierto: _requiereAlmacenCubierto,
        materialPeligroso: _materialPeligroso,
        imagenUrl: widget.producto?.imagenUrl,
        fichaTecnicaUrl: widget.producto?.fichaTecnicaUrl,
        activo: _activo,
        createdAt: widget.producto?.createdAt ?? now,
        updatedAt: now,
        deletedAt: null,
        syncId: widget.producto?.syncId,
        lastSync: null,
      );

      if (_isEditing) {
        context.read<ProductoBloc>().add(UpdateProducto(producto: producto));
      } else {
        context.read<ProductoBloc>().add(CreateProducto(producto: producto));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Producto' : 'Nuevo Producto'),
      ),
      body: BlocConsumer<ProductoBloc, ProductoState>(
        listener: (context, state) {
          if (state is ProductoCreated || state is ProductoUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditing
                      ? 'Producto actualizado correctamente'
                      : 'Producto creado correctamente',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); // Return true to indicate success
          } else if (state is ProductoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProductoLoading;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information
                  _buildSectionTitle('Información Básica'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nombreController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del Producto *',
                              hintText: 'Ej: Cemento Portland Tipo IP',
                              prefixIcon: Icon(Icons.inventory_2),
                            ),
                            enabled: !isLoading,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _codigoController,
                            decoration: const InputDecoration(
                              labelText: 'Código *',
                              hintText: 'Ej: CEM-IP-001',
                              prefixIcon: Icon(Icons.qr_code),
                            ),
                            enabled: !isLoading,
                            textCapitalization: TextCapitalization.characters,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El código es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descripcionController,
                            decoration: const InputDecoration(
                              labelText: 'Descripción',
                              hintText: 'Descripción detallada del producto',
                              prefixIcon: Icon(Icons.description),
                            ),
                            enabled: !isLoading,
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pricing
                  _buildSectionTitle('Precios'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _precioCompraController,
                            decoration: const InputDecoration(
                              labelText: 'Precio de Compra *',
                              hintText: '0.00',
                              prefixIcon: Icon(Icons.attach_money),
                              suffixText: 'USD',
                            ),
                            enabled: !isLoading,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El precio de compra es requerido';
                              }
                              final price = double.tryParse(value);
                              if (price == null || price < 0) {
                                return 'Ingrese un precio válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _precioVentaController,
                            decoration: const InputDecoration(
                              labelText: 'Precio de Venta *',
                              hintText: '0.00',
                              prefixIcon: Icon(Icons.attach_money),
                              suffixText: 'USD',
                            ),
                            enabled: !isLoading,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El precio de venta es requerido';
                              }
                              final price = double.tryParse(value);
                              if (price == null || price < 0) {
                                return 'Ingrese un precio válido';
                              }
                              final precioCompra = double.tryParse(
                                _precioCompraController.text,
                              );
                              if (precioCompra != null &&
                                  price < precioCompra) {
                                return 'El precio de venta debe ser mayor al de compra';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stock Control
                  _buildSectionTitle('Control de Stock'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _stockMinimoController,
                              decoration: const InputDecoration(
                                labelText: 'Stock Mínimo *',
                                hintText: '0',
                                prefixIcon: Icon(Icons.arrow_downward),
                              ),
                              enabled: !isLoading,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requerido';
                                }
                                final stock = int.tryParse(value);
                                if (stock == null || stock < 0) {
                                  return 'Inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _stockMaximoController,
                              decoration: const InputDecoration(
                                labelText: 'Stock Máximo *',
                                hintText: '100',
                                prefixIcon: Icon(Icons.arrow_upward),
                              ),
                              enabled: !isLoading,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Requerido';
                                }
                                final stockMax = int.tryParse(value);
                                final stockMin = int.tryParse(
                                  _stockMinimoController.text,
                                );
                                if (stockMax == null || stockMax < 0) {
                                  return 'Inválido';
                                }
                                if (stockMin != null && stockMax < stockMin) {
                                  return 'Debe ser > mínimo';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Physical Properties
                  _buildSectionTitle('Propiedades Físicas (Opcional)'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _pesoController,
                              decoration: const InputDecoration(
                                labelText: 'Peso Unitario',
                                hintText: '0.00',
                                prefixIcon: Icon(Icons.scale),
                                suffixText: 'kg',
                              ),
                              enabled: !isLoading,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _volumenController,
                              decoration: const InputDecoration(
                                labelText: 'Volumen Unitario',
                                hintText: '0.00',
                                prefixIcon: Icon(Icons.view_in_ar),
                                suffixText: 'm³',
                              ),
                              enabled: !isLoading,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,3}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Additional Info
                  _buildSectionTitle('Información Adicional (Opcional)'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _marcaController,
                            decoration: const InputDecoration(
                              labelText: 'Marca',
                              hintText: 'Ej: Holcim',
                              prefixIcon: Icon(Icons.branding_watermark),
                            ),
                            enabled: !isLoading,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _gradoCalidadController,
                            decoration: const InputDecoration(
                              labelText: 'Grado de Calidad',
                              hintText: 'Ej: Premium',
                              prefixIcon: Icon(Icons.star),
                            ),
                            enabled: !isLoading,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _normaTecnicaController,
                            decoration: const InputDecoration(
                              labelText: 'Norma Técnica',
                              hintText: 'Ej: ASTM C150',
                              prefixIcon: Icon(Icons.rule),
                            ),
                            enabled: !isLoading,
                            textCapitalization: TextCapitalization.characters,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Special Requirements
                  _buildSectionTitle('Requisitos Especiales'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Material Peligroso'),
                            subtitle: const Text('Requiere manejo especial'),
                            secondary: Icon(
                              Icons.warning,
                              color: _materialPeligroso
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            value: _materialPeligroso,
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _materialPeligroso = value;
                                    });
                                  },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: const Text('Requiere Almacén Cubierto'),
                            subtitle: const Text('Protección contra clima'),
                            secondary: Icon(
                              Icons.warehouse,
                              color: _requiereAlmacenCubierto
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            value: _requiereAlmacenCubierto,
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _requiereAlmacenCubierto = value;
                                    });
                                  },
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: const Text('Producto Activo'),
                            subtitle: const Text('Disponible para ventas'),
                            secondary: Icon(
                              Icons.check_circle,
                              color: _activo ? Colors.green : Colors.grey,
                            ),
                            value: _activo,
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _activo = value;
                                    });
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _handleSave,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        isLoading
                            ? 'Guardando...'
                            : _isEditing
                            ? 'Actualizar Producto'
                            : 'Crear Producto',
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
