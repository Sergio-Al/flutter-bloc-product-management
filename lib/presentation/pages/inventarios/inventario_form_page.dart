import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/inventario.dart';
import '../../blocs/inventario/inventario_bloc.dart';
import '../../blocs/inventario/inventario_event.dart';
import '../../blocs/inventario/inventario_state.dart';
import '../../blocs/producto/producto_bloc.dart';
import '../../blocs/producto/producto_event.dart';
import '../../blocs/producto/producto_state.dart';
import '../../blocs/almacen/almacen_bloc.dart';
import '../../blocs/almacen/almacen_event.dart';
import '../../blocs/almacen/almacen_state.dart';
import '../../blocs/tienda/tienda_bloc.dart';
import '../../blocs/tienda/tienda_event.dart';
import '../../blocs/tienda/tienda_state.dart';
import '../../blocs/lote/lote_bloc.dart';
import '../../blocs/lote/lote_event.dart';
import '../../blocs/lote/lote_state.dart';

class InventarioFormPage extends StatefulWidget {
  final Inventario? inventario;

  const InventarioFormPage({Key? key, this.inventario}) : super(key: key);

  @override
  State<InventarioFormPage> createState() => _InventarioFormPageState();
}

class _InventarioFormPageState extends State<InventarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cantidadActualController;
  late final TextEditingController _cantidadReservadaController;
  late final TextEditingController _valorTotalController;
  late final TextEditingController _ubicacionFisicaController;

  String? _selectedProductoId;
  String? _selectedAlmacenId;
  String? _selectedTiendaId;
  String? _selectedLoteId;

  bool _isEditing = false;

  late ProductoBloc _productoBloc;
  late AlmacenBloc _almacenBloc;
  late TiendaBloc _tiendaBloc;
  late LoteBloc _loteBloc;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.inventario != null;

    _selectedProductoId = widget.inventario?.productoId;
    _selectedAlmacenId = widget.inventario?.almacenId;
    _selectedTiendaId = widget.inventario?.tiendaId;
    _selectedLoteId = widget.inventario?.loteId;

    _productoBloc = getIt<ProductoBloc>()..add(const LoadProductosActivos());
    _almacenBloc = getIt<AlmacenBloc>()..add(const LoadAlmacenesActivos());
    _tiendaBloc = getIt<TiendaBloc>()..add(const LoadTiendasActivas());
    
    _loteBloc = getIt<LoteBloc>();
    if (_selectedProductoId != null) {
      _loteBloc.add(LoadLotesByProducto(_selectedProductoId!));
    } else {
      _loteBloc.add(const LoadLotesConStock());
    }

    _cantidadActualController = TextEditingController(
      text: widget.inventario?.cantidadActual.toString() ?? '',
    );
    _cantidadReservadaController = TextEditingController(
      text: widget.inventario?.cantidadReservada.toString() ?? '0',
    );
    _valorTotalController = TextEditingController(
      text: widget.inventario?.valorTotal.toStringAsFixed(2) ?? '',
    );
    _ubicacionFisicaController = TextEditingController(
      text: widget.inventario?.ubicacionFisica ?? '',
    );

    
  }

  @override
  void dispose() {
    _cantidadActualController.dispose();
    _cantidadReservadaController.dispose();
    _valorTotalController.dispose();
    _ubicacionFisicaController.dispose();
    _productoBloc.close();
    _almacenBloc.close();
    _tiendaBloc.close();
    _loteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productoBloc),
        BlocProvider.value(value: _almacenBloc),
        BlocProvider.value(value: _tiendaBloc),
        BlocProvider.value(value: _loteBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Editar Inventario' : 'Nuevo Inventario'),
        ),
        body: BlocConsumer<InventarioBloc, InventarioState>(
          listener: (context, state) {
            if (state is InventarioOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Operación exitosa'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
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
            final isLoading = state is InventarioLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionTitle('Referencias Principales'),
                  _buildProductoDropdown(isLoading),
                  const SizedBox(height: 16),
                  _buildAlmacenDropdown(isLoading),
                  const SizedBox(height: 16),
                  _buildTiendaDropdown(isLoading),
                  const SizedBox(height: 16),
                  _buildLoteDropdown(isLoading),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Cantidades'),
                  TextFormField(
                    controller: _cantidadActualController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad Actual *',
                      hintText: 'Stock actual',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La cantidad actual es requerida';
                      }
                      final cantidad = int.tryParse(value);
                      if (cantidad == null || cantidad < 0) {
                        return 'Ingrese una cantidad válida';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cantidadReservadaController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad Reservada',
                      hintText: 'Stock reservado',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      final reservada = int.tryParse(value);
                      if (reservada == null || reservada < 0) {
                        return 'Ingrese una cantidad válida';
                      }
                      final actual = int.tryParse(_cantidadActualController.text);
                      if (actual != null && reservada > actual) {
                        return 'No puede ser mayor a la cantidad actual';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Valor'),
                  TextFormField(
                    controller: _valorTotalController,
                    decoration: const InputDecoration(
                      labelText: 'Valor Total *',
                      hintText: 'Valor en \$',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El valor total es requerido';
                      }
                      final valor = double.tryParse(value);
                      if (valor == null || valor < 0) {
                        return 'Ingrese un valor válido';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Ubicación'),
                  TextFormField(
                    controller: _ubicacionFisicaController,
                    decoration: const InputDecoration(
                      labelText: 'Ubicación Física',
                      hintText: 'Ej: Pasillo A, Estante 3',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEditing ? 'Actualizar' : 'Crear'),
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

          if (productos.isEmpty) {
            return Column(
              children: [
                const InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Producto *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory),
                    errorText: 'No hay productos disponibles',
                  ),
                  child: SizedBox(height: 40),
                ),
              ],
            );
          }

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
                      _selectedLoteId = null; // Reset selected lote when product changes
                    });
                    
                    if (newValue != null) {
                      _loteBloc.add(LoadLotesByProducto(newValue));
                    }
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

  Widget _buildAlmacenDropdown(bool isLoading) {
    return BlocBuilder<AlmacenBloc, AlmacenState>(
      builder: (context, state) {
        if (state is AlmacenLoading) {
          return const InputDecorator(
            decoration: InputDecoration(
              labelText: 'Almacén *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.warehouse),
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

        if (state is AlmacenLoaded) {
          final almacenes = state.almacenes;

          if (almacenes.isEmpty) {
            return const InputDecorator(
              decoration: InputDecoration(
                labelText: 'Almacén *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warehouse),
                errorText: 'No hay almacenes disponibles',
              ),
              child: SizedBox(height: 40),
            );
          }

          return DropdownButtonFormField<String>(
            value: _selectedAlmacenId,
            decoration: const InputDecoration(
              labelText: 'Almacén *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.warehouse),
            ),
            hint: const Text('Seleccione un almacén'),
            items: almacenes.map<DropdownMenuItem<String>>((almacen) {
              return DropdownMenuItem<String>(
                value: almacen.id,
                child: Text(
                  almacen.nombre,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: isLoading
                ? null
                : (String? newValue) {
                    setState(() {
                      _selectedAlmacenId = newValue;
                    });
                  },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Debe seleccionar un almacén';
              }
              return null;
            },
            isExpanded: true,
          );
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Almacén *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.warehouse),
            errorText: 'Error al cargar almacenes',
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
              labelText: 'Tienda *',
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

          if (tiendas.isEmpty) {
            return const InputDecorator(
              decoration: InputDecoration(
                labelText: 'Tienda *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
                errorText: 'No hay tiendas disponibles',
              ),
              child: SizedBox(height: 40),
            );
          }

          return DropdownButtonFormField<String>(
            value: _selectedTiendaId,
            decoration: const InputDecoration(
              labelText: 'Tienda *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.store),
            ),
            hint: const Text('Seleccione una tienda'),
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
            labelText: 'Tienda *',
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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProductoId == null ||
        _selectedAlmacenId == null ||
        _selectedTiendaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todos los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cantidadActual = int.parse(_cantidadActualController.text.trim());
    final cantidadReservada = int.tryParse(_cantidadReservadaController.text.trim()) ?? 0;
    final cantidadDisponible = cantidadActual - cantidadReservada;

    final inventarioData = Inventario(
      id: _isEditing ? widget.inventario!.id : const Uuid().v4(),
      productoId: _selectedProductoId!,
      almacenId: _selectedAlmacenId!,
      tiendaId: _selectedTiendaId!,
      loteId: _selectedLoteId,
      cantidadActual: cantidadActual,
      cantidadReservada: cantidadReservada,
      cantidadDisponible: cantidadDisponible,
      valorTotal: double.parse(_valorTotalController.text.trim()),
      ubicacionFisica: _ubicacionFisicaController.text.trim().isEmpty
          ? null
          : _ubicacionFisicaController.text.trim(),
      ultimaActualizacion: DateTime.now(),
      createdAt: _isEditing ? widget.inventario!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      context.read<InventarioBloc>().add(UpdateInventario(inventarioData));
    } else {
      context.read<InventarioBloc>().add(CreateInventario(inventarioData));
    }
  }
}
