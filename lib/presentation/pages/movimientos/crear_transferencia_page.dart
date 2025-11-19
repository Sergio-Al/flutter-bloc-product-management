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

/// Page for creating Transferencia movimientos
class CrearTransferenciaPage extends StatefulWidget {
  const CrearTransferenciaPage({Key? key}) : super(key: key);

  @override
  State<CrearTransferenciaPage> createState() => _CrearTransferenciaPageState();
}

class _CrearTransferenciaPageState extends State<CrearTransferenciaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cantidadController;
  late final TextEditingController _vehiculoPlacaController;
  late final TextEditingController _conductorController;
  late final TextEditingController _numeroGuiaController;
  late final TextEditingController _observacionesController;

  String? _selectedProductoId;
  String? _selectedTiendaOrigenId;
  String? _selectedTiendaDestinoId;
  String? _selectedLoteId;

  late ProductoBloc _productoBloc;
  late TiendaBloc _tiendaBloc;
  late LoteBloc _loteBloc;

  @override
  void initState() {
    super.initState();

    _cantidadController = TextEditingController();
    _vehiculoPlacaController = TextEditingController();
    _conductorController = TextEditingController();
    _numeroGuiaController = TextEditingController();
    _observacionesController = TextEditingController();

    _productoBloc = getIt<ProductoBloc>()..add(const LoadProductosActivos());
    _tiendaBloc = getIt<TiendaBloc>()..add(const LoadTiendasActivas());
    _loteBloc = getIt<LoteBloc>()..add(const LoadLotesConStock());
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _vehiculoPlacaController.dispose();
    _conductorController.dispose();
    _numeroGuiaController.dispose();
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
          title: const Text('Transferencia entre Tiendas'),
        ),
        body: BlocConsumer<MovimientoBloc, MovimientoState>(
          listener: (context, state) {
            if (state is MovimientoOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Transferencia registrada exitosamente'),
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
                    color: Colors.orange[50],
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.swap_horiz, color: Colors.orange, size: 32),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Transferencia de Productos\nEntre Tiendas',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildProductoDropdown(isLoading),
                  const SizedBox(height: 16),
                  _buildTiendaOrigenDropdown(isLoading),
                  const SizedBox(height: 16),
                  _buildTiendaDestinoDropdown(isLoading),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inbox),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Cantidad requerida';
                      final cantidad = int.tryParse(value);
                      if (cantidad == null || cantidad <= 0) return 'Cantidad inválida';
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Información de Transporte (Opcional)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  _buildLoteDropdown(isLoading),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _vehiculoPlacaController,
                    decoration: const InputDecoration(
                      labelText: 'Placa del Vehículo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_shipping),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _conductorController,
                    decoration: const InputDecoration(
                      labelText: 'Conductor',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numeroGuiaController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Guía de Remisión',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.receipt_long),
                    ),
                    enabled: !isLoading,
                  ),
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
                          : const Icon(Icons.send),
                      label: const Text('Registrar Transferencia'),
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
            validator: (v) => v == null ? 'Producto requerido' : null,
          );
        }
        return const InputDecorator(decoration: InputDecoration(labelText: 'Producto *', border: OutlineInputBorder()));
      },
    );
  }

  Widget _buildTiendaOrigenDropdown(bool isLoading) {
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
            value: _selectedTiendaOrigenId,
            decoration: const InputDecoration(
              labelText: 'Tienda Origen *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.store, color: Colors.red),
            ),
            items: state.tiendas.map<DropdownMenuItem<String>>((t) =>
              DropdownMenuItem(value: t.id, child: Text(t.nombre))).toList(),
            onChanged: isLoading ? null : (v) => setState(() => _selectedTiendaOrigenId = v),
            validator: (v) {
              if (v == null) return 'Tienda origen requerida';
              if (v == _selectedTiendaDestinoId) return 'Debe ser diferente al destino';
              return null;
            },
          );
        }
        return const InputDecorator(decoration: InputDecoration(labelText: 'Tienda Origen *', border: OutlineInputBorder()));
      },
    );
  }

  Widget _buildTiendaDestinoDropdown(bool isLoading) {
    return BlocBuilder<TiendaBloc, TiendaState>(
      builder: (context, state) {
        if (state is TiendaLoading) {
          return const InputDecorator(
            decoration: InputDecoration(labelText: 'Tienda Destino *', border: OutlineInputBorder()),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is TiendaLoaded) {
          return DropdownButtonFormField<String>(
            value: _selectedTiendaDestinoId,
            decoration: const InputDecoration(
              labelText: 'Tienda Destino *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.store, color: Colors.green),
            ),
            items: state.tiendas.map<DropdownMenuItem<String>>((t) =>
              DropdownMenuItem(value: t.id, child: Text(t.nombre))).toList(),
            onChanged: isLoading ? null : (v) => setState(() => _selectedTiendaDestinoId = v),
            validator: (v) {
              if (v == null) return 'Tienda destino requerida';
              if (v == _selectedTiendaOrigenId) return 'Debe ser diferente al origen';
              return null;
            },
          );
        }
        return const InputDecorator(decoration: InputDecoration(labelText: 'Tienda Destino *', border: OutlineInputBorder()));
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

    context.read<MovimientoBloc>().add(CreateTransferenciaEvent(
      productoId: _selectedProductoId!,
      tiendaOrigenId: _selectedTiendaOrigenId!,
      tiendaDestinoId: _selectedTiendaDestinoId!,
      cantidad: cantidad,
      loteId: _selectedLoteId,
      vehiculoPlaca: _vehiculoPlacaController.text.trim().isEmpty ? null : _vehiculoPlacaController.text.trim(),
      conductor: _conductorController.text.trim().isEmpty ? null : _conductorController.text.trim(),
      numeroGuiaRemision: _numeroGuiaController.text.trim().isEmpty ? null : _numeroGuiaController.text.trim(),
      observaciones: _observacionesController.text.trim().isEmpty ? null : _observacionesController.text.trim(),
    ));
  }
}
