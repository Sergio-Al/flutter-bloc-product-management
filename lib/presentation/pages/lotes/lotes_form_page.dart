import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/lote.dart';
import '../../../domain/entities/producto.dart';
import '../../../domain/entities/proveedor.dart';
import '../../blocs/lote/lote_bloc.dart';
import '../../blocs/lote/lote_event.dart';
import '../../blocs/lote/lote_state.dart';
import '../../blocs/producto/producto_bloc.dart';
import '../../blocs/producto/producto_event.dart';
import '../../blocs/producto/producto_state.dart';
import '../../blocs/proveedor/proveedor_bloc.dart';
import '../../blocs/proveedor/proveedor_event.dart';
import '../../blocs/proveedor/proveedor_state.dart';

class LotesFormPage extends StatefulWidget {
  final Lote? lote;

  const LotesFormPage({Key? key, this.lote}) : super(key: key);

  @override
  State<LotesFormPage> createState() => _LotesFormPageState();
}

class _LotesFormPageState extends State<LotesFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numeroLoteController;
  late final TextEditingController _numeroFacturaController;
  late final TextEditingController _cantidadInicialController;
  late final TextEditingController _cantidadActualController;
  late final TextEditingController _certificadoCalidadUrlController;
  late final TextEditingController _observacionesController;

  // Dropdowns
  String? _selectedProductoId;
  String? _selectedProveedorId;

  DateTime? _fechaFabricacion;
  DateTime? _fechaVencimiento;

  bool _isEditing = false;

  // BLoCs for dropdowns
  late ProductoBloc _productoBloc;
  late ProveedorBloc _proveedorBloc;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.lote != null;

    // Initialize BLoCs - Use LoadProductosActivos which reads from LOCAL database
    _productoBloc = getIt<ProductoBloc>()..add(const LoadProductosActivos());
    _proveedorBloc = getIt<ProveedorBloc>()..add(const LoadProveedoresActivos());

    _numeroLoteController = TextEditingController(
      text: widget.lote?.numeroLote ?? '',
    );
    _numeroFacturaController = TextEditingController(
      text: widget.lote?.numeroFactura ?? '',
    );
    _cantidadInicialController = TextEditingController(
      text: widget.lote?.cantidadInicial.toString() ?? '',
    );
    _cantidadActualController = TextEditingController(
      text: widget.lote?.cantidadActual.toString() ?? '',
    );
    _certificadoCalidadUrlController = TextEditingController(
      text: widget.lote?.certificadoCalidadUrl ?? '',
    );
    _observacionesController = TextEditingController(
      text: widget.lote?.observaciones ?? '',
    );

    // Set selected IDs if editing
    _selectedProductoId = widget.lote?.productoId;
    _selectedProveedorId = widget.lote?.proveedorId;

    _fechaFabricacion = widget.lote?.fechaFabricacion;
    _fechaVencimiento = widget.lote?.fechaVencimiento;
  }

  @override
  void dispose() {
    _numeroLoteController.dispose();
    _numeroFacturaController.dispose();
    _cantidadInicialController.dispose();
    _cantidadActualController.dispose();
    _certificadoCalidadUrlController.dispose();
    _observacionesController.dispose();
    _productoBloc.close();
    _proveedorBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productoBloc),
        BlocProvider.value(value: _proveedorBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Editar Lote' : 'Nuevo Lote'),
        ),
        body: BlocConsumer<LoteBloc, LoteState>(
        listener: (context, state) {
          if (state is LoteOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
          if (state is LoteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoteLoading;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle('Información Básica'),
                TextFormField(
                  controller: _numeroLoteController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Lote *',
                    hintText: 'Ej: LOTE-2024-001',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.tag),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El número de lote es requerido';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                _buildProductoDropdown(isLoading),
                const SizedBox(height: 16),
                _buildProveedorDropdown(isLoading),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _numeroFacturaController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Factura',
                    hintText: 'Factura de compra',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.receipt),
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Fechas'),
                ListTile(
                  title: const Text('Fecha de Fabricación'),
                  subtitle: Text(
                    _fechaFabricacion != null
                        ? _formatDate(_fechaFabricacion!)
                        : 'No seleccionada',
                  ),
                  leading: const Icon(Icons.factory),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: isLoading ? null : () => _selectDate(context, true),
                  ),
                  onTap: isLoading ? null : () => _selectDate(context, true),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Fecha de Vencimiento'),
                  subtitle: Text(
                    _fechaVencimiento != null
                        ? _formatDate(_fechaVencimiento!)
                        : 'No seleccionada',
                  ),
                  leading: const Icon(Icons.event_busy),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: isLoading ? null : () => _selectDate(context, false),
                  ),
                  onTap: isLoading ? null : () => _selectDate(context, false),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Cantidades'),
                TextFormField(
                  controller: _cantidadInicialController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad Inicial *',
                    hintText: 'Cantidad recibida',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.add_box),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La cantidad inicial es requerida';
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
                  controller: _cantidadActualController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad Actual *',
                    hintText: 'Cantidad disponible',
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
                    final inicial = int.tryParse(_cantidadInicialController.text);
                    if (inicial != null && cantidad > inicial) {
                      return 'No puede ser mayor a la cantidad inicial';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Certificado de Calidad'),
                TextFormField(
                  controller: _certificadoCalidadUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL del Certificado',
                    hintText: 'URL del documento de certificación',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.verified),
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Observaciones'),
                TextFormField(
                  controller: _observacionesController,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                    hintText: 'Notas adicionales sobre el lote',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 3,
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
                const SizedBox(height: 8),
                Text(
                  'Debe crear productos antes de crear lotes',
                  style: TextStyle(color: Colors.orange[700], fontSize: 12),
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
            items: productos.map((Producto producto) {
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

  Widget _buildProveedorDropdown(bool isLoading) {
    return BlocBuilder<ProveedorBloc, ProveedorState>(
      builder: (context, state) {
        if (state is ProveedorLoading) {
          return const InputDecorator(
            decoration: InputDecoration(
              labelText: 'Proveedor',
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
              labelText: 'Proveedor (Opcional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
            hint: const Text('Seleccione un proveedor'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Ninguno'),
              ),
              ...proveedores.map((Proveedor proveedor) {
                return DropdownMenuItem<String>(
                  value: proveedor.id,
                  child: Text(
                    proveedor.razonSocial,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ],
            onChanged: isLoading
                ? null
                : (String? newValue) {
                    setState(() {
                      _selectedProveedorId = newValue;
                    });
                  },
            isExpanded: true,
          );
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Proveedor (Opcional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context, bool isFabricacion) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFabricacion
          ? (_fechaFabricacion ?? DateTime.now())
          : (_fechaVencimiento ?? DateTime.now().add(const Duration(days: 365))),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFabricacion) {
          _fechaFabricacion = picked;
        } else {
          _fechaVencimiento = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate that producto is selected
    if (_selectedProductoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar un producto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final loteData = Lote(
      id: _isEditing ? widget.lote!.id : const Uuid().v4(),
      numeroLote: _numeroLoteController.text.trim(),
      productoId: _selectedProductoId!,
      fechaFabricacion: _fechaFabricacion,
      fechaVencimiento: _fechaVencimiento,
      proveedorId: _selectedProveedorId,
      numeroFactura: _numeroFacturaController.text.trim().isEmpty
          ? null
          : _numeroFacturaController.text.trim(),
      cantidadInicial: int.parse(_cantidadInicialController.text.trim()),
      cantidadActual: int.parse(_cantidadActualController.text.trim()),
      certificadoCalidadUrl: _certificadoCalidadUrlController.text.trim().isEmpty
          ? null
          : _certificadoCalidadUrlController.text.trim(),
      observaciones: _observacionesController.text.trim().isEmpty
          ? null
          : _observacionesController.text.trim(),
      createdAt: _isEditing ? widget.lote!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      context.read<LoteBloc>().add(UpdateLote(loteData));
    } else {
      context.read<LoteBloc>().add(CreateLote(loteData));
    }
  }
}
