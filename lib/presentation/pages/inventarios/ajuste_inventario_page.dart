import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/inventario.dart';
import '../../blocs/inventario/inventario_bloc.dart';
import '../../blocs/inventario/inventario_event.dart';
import '../../blocs/inventario/inventario_state.dart';

class AjusteInventarioPage extends StatefulWidget {
  final Inventario inventario;

  const AjusteInventarioPage({
    Key? key,
    required this.inventario,
  }) : super(key: key);

  @override
  State<AjusteInventarioPage> createState() => _AjusteInventarioPageState();
}

class _AjusteInventarioPageState extends State<AjusteInventarioPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nuevaCantidadController;
  late final TextEditingController _motivoController;

  String _tipoAjuste = 'manual'; // manual, incremento, decremento

  @override
  void initState() {
    super.initState();
    _nuevaCantidadController = TextEditingController(
      text: widget.inventario.cantidadActual.toString(),
    );
    _motivoController = TextEditingController();
  }

  @override
  void dispose() {
    _nuevaCantidadController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustar Inventario'),
        backgroundColor: Colors.purple,
      ),
      body: BlocConsumer<InventarioBloc, InventarioState>(
        listener: (context, state) {
          if (state is InventarioOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Ajuste realizado'),
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
                _buildInfoCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('Tipo de Ajuste'),
                Card(
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Ajuste Manual'),
                        subtitle: const Text('Establecer cantidad exacta'),
                        value: 'manual',
                        groupValue: _tipoAjuste,
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _tipoAjuste = value!;
                                  _nuevaCantidadController.text =
                                      widget.inventario.cantidadActual.toString();
                                });
                              },
                      ),
                      RadioListTile<String>(
                        title: const Text('Incrementar'),
                        subtitle: const Text('Añadir unidades'),
                        value: 'incremento',
                        groupValue: _tipoAjuste,
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _tipoAjuste = value!;
                                  _nuevaCantidadController.text = '';
                                });
                              },
                      ),
                      RadioListTile<String>(
                        title: const Text('Decrementar'),
                        subtitle: const Text('Restar unidades'),
                        value: 'decremento',
                        groupValue: _tipoAjuste,
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _tipoAjuste = value!;
                                  _nuevaCantidadController.text = '';
                                });
                              },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Cantidad'),
                TextFormField(
                  controller: _nuevaCantidadController,
                  decoration: InputDecoration(
                    labelText: _tipoAjuste == 'manual'
                        ? 'Nueva Cantidad Total *'
                        : _tipoAjuste == 'incremento'
                            ? 'Cantidad a Añadir *'
                            : 'Cantidad a Restar *',
                    hintText: 'Ingrese la cantidad',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      _tipoAjuste == 'incremento'
                          ? Icons.add_circle
                          : _tipoAjuste == 'decremento'
                              ? Icons.remove_circle
                              : Icons.edit,
                      color: _tipoAjuste == 'incremento'
                          ? Colors.green
                          : _tipoAjuste == 'decremento'
                              ? Colors.red
                              : Colors.blue,
                    ),
                    helperText: _getHelperText(),
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
                    if (cantidad == null || cantidad < 0) {
                      return 'Ingrese una cantidad válida';
                    }

                    if (_tipoAjuste == 'manual') {
                      // No additional validation needed for manual
                    } else if (_tipoAjuste == 'decremento') {
                      if (cantidad > widget.inventario.cantidadActual) {
                        return 'No puede restar más de lo disponible';
                      }
                    }

                    return null;
                  },
                  enabled: !isLoading,
                  autofocus: true,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Motivo del Ajuste'),
                TextFormField(
                  controller: _motivoController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo *',
                    hintText: 'Ej: Recuento físico, Merma, Error de inventario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El motivo es requerido';
                    }
                    if (value.trim().length < 10) {
                      return 'El motivo debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 32),
                _buildPreviewCard(),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _submitAjuste,
                    icon: const Icon(Icons.check_circle),
                    label: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Confirmar Ajuste'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventario Actual',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Ubicación', widget.inventario.ubicacionFisica ?? 'Sin ubicación'),
            _buildInfoRow('Stock Actual', '${widget.inventario.cantidadActual} unidades'),
            _buildInfoRow('Stock Disponible', '${widget.inventario.cantidadDisponible} unidades'),
            _buildInfoRow('Stock Reservado', '${widget.inventario.cantidadReservada} unidades'),
            _buildInfoRow('Valor Total', '\$${widget.inventario.valorTotal.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final nuevaCantidad = _calculateNewQuantity();
    if (nuevaCantidad == null) {
      return const SizedBox.shrink();
    }

    final diferencia = nuevaCantidad - widget.inventario.cantidadActual;
    final esIncremento = diferencia > 0;

    return Card(
      color: esIncremento ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  esIncremento ? Icons.trending_up : Icons.trending_down,
                  color: esIncremento ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Vista Previa del Ajuste',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow('Stock Actual', '${widget.inventario.cantidadActual} unidades'),
            _buildInfoRow(
              'Cambio',
              '${esIncremento ? '+' : ''}$diferencia unidades',
              valueColor: esIncremento ? Colors.green : Colors.orange,
            ),
            _buildInfoRow(
              'Nuevo Stock',
              '$nuevaCantidad unidades',
              valueColor: Colors.blue,
            ),
          ],
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

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getHelperText() {
    final cantidadActual = widget.inventario.cantidadActual;
    switch (_tipoAjuste) {
      case 'manual':
        return 'Cantidad actual: $cantidadActual';
      case 'incremento':
        return 'Se añadirá a los $cantidadActual actuales';
      case 'decremento':
        return 'Se restará de los $cantidadActual actuales';
      default:
        return '';
    }
  }

  int? _calculateNewQuantity() {
    final text = _nuevaCantidadController.text.trim();
    if (text.isEmpty) return null;

    final cantidad = int.tryParse(text);
    if (cantidad == null) return null;

    switch (_tipoAjuste) {
      case 'manual':
        return cantidad;
      case 'incremento':
        return widget.inventario.cantidadActual + cantidad;
      case 'decremento':
        return widget.inventario.cantidadActual - cantidad;
      default:
        return null;
    }
  }

  void _submitAjuste() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nuevaCantidad = _calculateNewQuantity();
    if (nuevaCantidad == null || nuevaCantidad < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cantidad inválida'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar Ajuste'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Está seguro de realizar este ajuste?'),
            const SizedBox(height: 16),
            Text('Stock actual: ${widget.inventario.cantidadActual}'),
            Text(
              'Nuevo stock: $nuevaCantidad',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Diferencia: ${nuevaCantidad - widget.inventario.cantidadActual}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<InventarioBloc>().add(
                    AjustarInventarioEvent(
                      inventarioId: widget.inventario.id,
                      nuevaCantidad: nuevaCantidad,
                      motivo: _motivoController.text.trim(),
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
