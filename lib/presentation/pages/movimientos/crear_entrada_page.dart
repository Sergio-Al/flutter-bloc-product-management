import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../blocs/movimiento/movimiento_bloc.dart';
import '../../blocs/movimiento/movimiento_event.dart';
import '../../blocs/movimiento/movimiento_state.dart';
import '../../blocs/producto/producto_bloc.dart';
import '../../blocs/producto/producto_event.dart';
import '../../blocs/producto/producto_state.dart';
import '../../blocs/tienda/tienda_bloc.dart';
import '../../blocs/tienda/tienda_event.dart';
import '../../blocs/tienda/tienda_state.dart';
import '../../blocs/proveedor/proveedor_bloc.dart';
import '../../blocs/proveedor/proveedor_event.dart';
import '../../blocs/proveedor/proveedor_state.dart';
import '../../blocs/lote/lote_bloc.dart';
import '../../blocs/lote/lote_event.dart';
import '../../blocs/lote/lote_state.dart';

/// Page for creating Entrada movimientos (COMPRA)
class CrearEntradaPage extends StatefulWidget {
  const CrearEntradaPage({Key? key}) : super(key: key);

  @override
  State<CrearEntradaPage> createState() => _CrearEntradaPageState();
}

class _CrearEntradaPageState extends State<CrearEntradaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cantidadController;
  late final TextEditingController _costoUnitarioController;
  late final TextEditingController _numeroFacturaController;
  late final TextEditingController _observacionesController;

  String? _selectedProductoId;
  String? _selectedTiendaId;
  String? _selectedProveedorId;
  String? _selectedLoteId;

  // BLoCs
  late ProductoBloc _productoBloc;
  late TiendaBloc _tiendaBloc;
  late ProveedorBloc _proveedorBloc;
  late LoteBloc _loteBloc;

  @override
  void initState() {
    super.initState();

    _cantidadController = TextEditingController();
    _costoUnitarioController = TextEditingController();
    _numeroFacturaController = TextEditingController();
    _observacionesController = TextEditingController();

    _productoBloc = getIt<ProductoBloc>()..add(const LoadProductosActivos());
    _tiendaBloc = getIt<TiendaBloc>()..add(const LoadTiendasActivas());
    _proveedorBloc = getIt<ProveedorBloc>()..add(const LoadProveedoresActivos());
    _loteBloc = getIt<LoteBloc>()..add(const LoadLotesConStock());
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _costoUnitarioController.dispose();
    _numeroFacturaController.dispose();
    _observacionesController.dispose();
    _productoBloc.close();
    _tiendaBloc.close();
    _proveedorBloc.close();
    _loteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productoBloc),
        BlocProvider.value(value: _tiendaBloc),
        BlocProvider.value(value: _proveedorBloc),
        BlocProvider.value(value: _loteBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entrada de Productos - Compra'),
        ),
        body: BlocConsumer<MovimientoBloc, MovimientoState>(
          listener: (context, state) {
            if (state is MovimientoOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Compra registrada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
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
            final isLoading = state is MovimientoLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    color: Colors.blue[50],
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.shopping_cart, color: Colors.blue, size: 32),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Compra de Productos',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Registra la entrada de productos por compra',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Información del Producto'),
                  _buildProductoDropdown(isLoading),
                  const SizedBox(height: 16),
                  _buildTiendaDropdown(isLoading),
                  const SizedBox(height: 16),
                  _buildProveedorDropdown(isLoading),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Cantidad y Costos'),
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad *',
                      hintText: 'Unidades compradas',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.add_box),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La cantidad es requerida';
                      }
                      final cantidad = int.tryParse(value);
                      if (cantidad == null || cantidad <= 0) {
                        return 'Ingrese una cantidad válida';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _costoUnitarioController,
                    decoration: const InputDecoration(
                      labelText: 'Costo Unitario *',
                      hintText: 'Precio de compra por unidad',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El costo unitario es requerido';
                      }
                      final costo = double.tryParse(value);
                      if (costo == null || costo <= 0) {
                        return 'Ingrese un costo válido';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  if (_cantidadController.text.isNotEmpty &&
                      _costoUnitarioController.text.isNotEmpty)
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total de Compra:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${_calcularTotal()}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Documentos (Opcional)'),
                  _buildLoteDropdown(isLoading),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numeroFacturaController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Factura',
                      hintText: 'Factura del proveedor',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.receipt),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Observaciones'),
                  TextFormField(
                    controller: _observacionesController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                      hintText: 'Notas adicionales',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.notes),
                    ),
                    maxLines: 3,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _submitForm,
                      icon: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle),
                      label: const Text('Registrar Compra'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildProductoDropdown(bool isLoading) {
    return BlocBuilder<ProductoBloc, ProductoState>(
      builder: (context, state) {
        if (state is ProductoLoading) {
          return const InputDecorator(
            decoration: InputDecoration(
              labelText: 'Producto *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.inventory),
            ),
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (state is ProductoLoaded) {
          final productos = state.productos;

          return DropdownButtonFormField<String>(
            value: _selectedProductoId,
            decoration: const InputDecoration(
              labelText: 'Producto *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.inventory),
            ),
            hint: const Text('Seleccione un producto'),
            items: productos.map<DropdownMenuItem<String>>((producto) {
              return DropdownMenuItem<String>(
                value: producto.id,
                child: Text(
                  producto.nombre,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: isLoading
                ? null
                : (String? newValue) {
                    setState(() {
                      _selectedProductoId = newValue;
                    });
                  },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Debe seleccionar un producto';
              }
              return null;
            },
            isExpanded: true,
          );
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Producto *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.inventory),
            errorText: 'Error al cargar productos',
          ),
          items: const [],
          onChanged: null,
        );
      },
    );
  }

  Widget _buildTiendaDropdown(bool isLoading) {
    return BlocBuilder<TiendaBloc, TiendaState>(
      builder: (context, state) {
        if (state is TiendaLoading) {
          return const InputDecorator(
            decoration: InputDecoration(
              labelText: 'Tienda Destino *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.store),
            ),
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (state is TiendaLoaded) {
          final tiendas = state.tiendas;

          return DropdownButtonFormField<String>(
            value: _selectedTiendaId,
            decoration: const InputDecoration(
              labelText: 'Tienda Destino *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.store),
            ),
            hint: const Text('Seleccione tienda'),
            items: tiendas.map<DropdownMenuItem<String>>((tienda) {
              return DropdownMenuItem<String>(
                value: tienda.id,
                child: Text(
                  tienda.nombre,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: isLoading
                ? null
                : (String? newValue) {
                    setState(() {
                      _selectedTiendaId = newValue;
                    });
                  },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Debe seleccionar una tienda';
              }
              return null;
            },
            isExpanded: true,
          );
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Tienda Destino *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.store),
            errorText: 'Error al cargar tiendas',
          ),
          items: const [],
          onChanged: null,
        );
      },
    );
  }

  Widget _buildProveedorDropdown(bool isLoading) {
    return BlocBuilder<ProveedorBloc, ProveedorState>(
      builder: (context, state) {
        if (state is ProveedorLoading) {
          return const InputDecorator(
            decoration: InputDecoration(
              labelText: 'Proveedor *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (state is ProveedorLoaded) {
          final proveedores = state.proveedores;

          return DropdownButtonFormField<String>(
            value: _selectedProveedorId,
            decoration: const InputDecoration(
              labelText: 'Proveedor *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
            hint: const Text('Seleccione proveedor'),
            items: proveedores.map<DropdownMenuItem<String>>((proveedor) {
              return DropdownMenuItem<String>(
                value: proveedor.id,
                child: Text(
                  proveedor.razonSocial,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: isLoading
                ? null
                : (String? newValue) {
                    setState(() {
                      _selectedProveedorId = newValue;
                    });
                  },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Debe seleccionar un proveedor';
              }
              return null;
            },
            isExpanded: true,
          );
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Proveedor *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
            errorText: 'Error al cargar proveedores',
          ),
          items: const [],
          onChanged: null,
        );
      },
    );
  }

  Widget _buildLoteDropdown(bool isLoading) {
    return BlocBuilder<LoteBloc, LoteState>(
      builder: (context, state) {
        if (state is LoteLoading) {
          return const InputDecorator(
            decoration: InputDecoration(
              labelText: 'Lote (Opcional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.tag),
            ),
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (state is LoteLoaded) {
          final lotes = state.lotes;

          return DropdownButtonFormField<String>(
            value: _selectedLoteId,
            decoration: const InputDecoration(
              labelText: 'Lote (Opcional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.tag),
            ),
            hint: const Text('Seleccione un lote'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Ninguno'),
              ),
              ...lotes.map<DropdownMenuItem<String>>((lote) {
                return DropdownMenuItem<String>(
                  value: lote.id,
                  child: Text(
                    lote.numeroLote,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ],
            onChanged: isLoading
                ? null
                : (String? newValue) {
                    setState(() {
                      _selectedLoteId = newValue;
                    });
                  },
            isExpanded: true,
          );
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Lote (Opcional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.tag),
          ),
          items: const [
            DropdownMenuItem<String>(
              value: null,
              child: Text('Ninguno'),
            ),
          ],
          onChanged: isLoading ? null : (value) {},
        );
      },
    );
  }

  String _calcularTotal() {
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    final costoUnitario = double.tryParse(_costoUnitarioController.text) ?? 0.0;
    final total = cantidad * costoUnitario;
    return total.toStringAsFixed(2);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cantidad = int.parse(_cantidadController.text.trim());
    final costoUnitario = double.parse(_costoUnitarioController.text.trim());

    context.read<MovimientoBloc>().add(
          CreateCompraEvent(
            productoId: _selectedProductoId!,
            tiendaDestinoId: _selectedTiendaId!,
            proveedorId: _selectedProveedorId!,
            cantidad: cantidad,
            costoUnitario: costoUnitario,
            loteId: _selectedLoteId,
            numeroFactura: _numeroFacturaController.text.trim().isEmpty
                ? null
                : _numeroFacturaController.text.trim(),
            observaciones: _observacionesController.text.trim().isEmpty
                ? null
                : _observacionesController.text.trim(),
          ),
        );
  }
}
