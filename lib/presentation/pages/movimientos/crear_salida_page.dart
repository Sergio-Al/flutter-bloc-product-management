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
import '../../blocs/lote/lote_bloc.dart';
import '../../blocs/lote/lote_event.dart';
import '../../blocs/lote/lote_state.dart';

/// Page for creating Salida movimientos (VENTA, MERMA, DEVOLUCION)
class CrearSalidaPage extends StatefulWidget {
  const CrearSalidaPage({Key? key}) : super(key: key);

  @override
  State<CrearSalidaPage> createState() => _CrearSalidaPageState();
}

class _CrearSalidaPageState extends State<CrearSalidaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cantidadController;
  late final TextEditingController _costoUnitarioController;
  late final TextEditingController _numeroFacturaController;
  late final TextEditingController _motivoController;
  late final TextEditingController _observacionesController;

  String? _selectedProductoId;
  String? _selectedTiendaId;
  String? _selectedLoteId;
  String _tipoSalida = 'VENTA'; // VENTA, MERMA, DEVOLUCION

  late ProductoBloc _productoBloc;
  late TiendaBloc _tiendaBloc;
  late LoteBloc _loteBloc;

  @override
  void initState() {
    super.initState();

    _cantidadController = TextEditingController();
    _costoUnitarioController = TextEditingController();
    _numeroFacturaController = TextEditingController();
    _motivoController = TextEditingController();
    _observacionesController = TextEditingController();

    _productoBloc = getIt<ProductoBloc>()..add(const LoadProductosActivos());
    _tiendaBloc = getIt<TiendaBloc>()..add(const LoadTiendasActivas());
    _loteBloc = getIt<LoteBloc>()..add(const LoadLotesConStock());
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _costoUnitarioController.dispose();
    _numeroFacturaController.dispose();
    _motivoController.dispose();
    _observacionesController.dispose();
    _productoBloc.close();
    _tiendaBloc.close();
    _loteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productoBloc),
        BlocProvider.value(value: _tiendaBloc),
        BlocProvider.value(value: _loteBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Salida de Productos'),
        ),
        body: BlocConsumer<MovimientoBloc, MovimientoState>(
          listener: (context, state) {
            if (state is MovimientoOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Salida registrada exitosamente'),
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
                  _buildTipoSelector(),
                  const SizedBox(height: 16),
                  _buildProductoDropdown(isLoading),
                  const SizedBox(height: 16),
                  _buildTiendaDropdown(isLoading),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.remove_circle),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Requerido';
                      final cantidad = int.tryParse(value);
                      if (cantidad == null || cantidad <= 0) return 'Cantidad inválida';
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  if (_tipoSalida == 'VENTA') ...[
                    TextFormField(
                      controller: _costoUnitarioController,
                      decoration: const InputDecoration(
                        labelText: 'Precio Unitario *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _numeroFacturaController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Factura',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.receipt),
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_tipoSalida != 'VENTA') ...[
                    TextFormField(
                      controller: _motivoController,
                      decoration: InputDecoration(
                        labelText: 'Motivo *',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.comment),
                        hintText: _tipoSalida == 'MERMA'
                            ? 'Ej: Producto dañado'
                            : 'Ej: Devolución cliente',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Motivo requerido';
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildLoteDropdown(isLoading),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _observacionesController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
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
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_circle),
                      label: Text('Registrar ${_tipoSalida == 'VENTA' ? 'Venta' : _tipoSalida == 'MERMA' ? 'Merma' : 'Devolución'}'),
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

  Widget _buildTipoSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tipo de Salida', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'VENTA', label: Text('Venta'), icon: Icon(Icons.point_of_sale)),
                ButtonSegment(value: 'MERMA', label: Text('Merma'), icon: Icon(Icons.trending_down)),
                ButtonSegment(value: 'DEVOLUCION', label: Text('Devolución'), icon: Icon(Icons.keyboard_return)),
              ],
              selected: {_tipoSalida},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _tipoSalida = newSelection.first;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductoDropdown(bool isLoading) {
    return BlocBuilder<ProductoBloc, ProductoState>(
      builder: (context, state) {
        if (state is ProductoLoading) {
          return const InputDecorator(
            decoration: InputDecoration(labelText: 'Producto *', border: OutlineInputBorder()),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ProductoLoaded) {
          return DropdownButtonFormField<String>(
            value: _selectedProductoId,
            decoration: const InputDecoration(labelText: 'Producto *', border: OutlineInputBorder()),
            items: state.productos.map<DropdownMenuItem<String>>((p) =>
              DropdownMenuItem(value: p.id, child: Text(p.nombre))).toList(),
            onChanged: isLoading ? null : (v) => setState(() => _selectedProductoId = v),
            validator: (v) => v == null ? 'Requerido' : null,
          );
        }
        return const InputDecorator(decoration: InputDecoration(labelText: 'Producto *', border: OutlineInputBorder()));
      },
    );
  }

  Widget _buildTiendaDropdown(bool isLoading) {
    return BlocBuilder<TiendaBloc, TiendaState>(
      builder: (context, state) {
        if (state is TiendaLoading) {
          return const InputDecorator(
            decoration: InputDecoration(labelText: 'Tienda Origen *', border: OutlineInputBorder()),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is TiendaLoaded) {
          return DropdownButtonFormField<String>(
            value: _selectedTiendaId,
            decoration: const InputDecoration(labelText: 'Tienda Origen *', border: OutlineInputBorder()),
            items: state.tiendas.map<DropdownMenuItem<String>>((t) =>
              DropdownMenuItem(value: t.id, child: Text(t.nombre))).toList(),
            onChanged: isLoading ? null : (v) => setState(() => _selectedTiendaId = v),
            validator: (v) => v == null ? 'Requerido' : null,
          );
        }
        return const InputDecorator(decoration: InputDecoration(labelText: 'Tienda Origen *', border: OutlineInputBorder()));
      },
    );
  }

  Widget _buildLoteDropdown(bool isLoading) {
    return BlocBuilder<LoteBloc, LoteState>(
      builder: (context, state) {
        if (state is LoteLoaded) {
          return DropdownButtonFormField<String>(
            value: _selectedLoteId,
            decoration: const InputDecoration(labelText: 'Lote (Opcional)', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem(value: null, child: Text('Ninguno')),
              ...state.lotes.map<DropdownMenuItem<String>>((l) =>
                DropdownMenuItem(value: l.id, child: Text(l.numeroLote))).toList(),
            ],
            onChanged: isLoading ? null : (v) => setState(() => _selectedLoteId = v),
          );
        }
        return const InputDecorator(decoration: InputDecoration(labelText: 'Lote', border: OutlineInputBorder()));
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final cantidad = int.parse(_cantidadController.text);
    final costoUnitario = _tipoSalida == 'VENTA' ? double.parse(_costoUnitarioController.text) : 0.0;

    if (_tipoSalida == 'VENTA') {
      context.read<MovimientoBloc>().add(CreateVentaEvent(
        productoId: _selectedProductoId!,
        tiendaOrigenId: _selectedTiendaId!,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        loteId: _selectedLoteId,
        numeroFactura: _numeroFacturaController.text.trim().isEmpty ? null : _numeroFacturaController.text.trim(),
        observaciones: _observacionesController.text.trim().isEmpty ? null : _observacionesController.text.trim(),
      ));
    } else if (_tipoSalida == 'MERMA') {
      context.read<MovimientoBloc>().add(CreateMermaEvent(
        productoId: _selectedProductoId!,
        tiendaId: _selectedTiendaId!,
        cantidad: cantidad,
        motivo: _motivoController.text.trim(),
        observaciones: _observacionesController.text.trim().isEmpty ? null : _observacionesController.text.trim(),
      ));
    } else {
      context.read<MovimientoBloc>().add(CreateDevolucionEvent(
        productoId: _selectedProductoId!,
        tiendaId: _selectedTiendaId!,
        cantidad: cantidad,
        motivo: _motivoController.text.trim(),
        numeroFactura: _numeroFacturaController.text.trim().isEmpty ? null : _numeroFacturaController.text.trim(),
        observaciones: _observacionesController.text.trim().isEmpty ? null : _observacionesController.text.trim(),
      ));
    }
  }
}
