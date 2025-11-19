import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movimiento.dart';
import '../../blocs/movimiento/movimiento_bloc.dart';
import '../../blocs/movimiento/movimiento_event.dart';
import '../../blocs/movimiento/movimiento_state.dart';

class MovimientoDetailPage extends StatefulWidget {
  final String movimientoId;

  const MovimientoDetailPage({
    Key? key,
    required this.movimientoId,
  }) : super(key: key);

  @override
  State<MovimientoDetailPage> createState() => _MovimientoDetailPageState();
}

class _MovimientoDetailPageState extends State<MovimientoDetailPage> {
  bool _wasModified = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          Navigator.of(context).pop(_wasModified);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de Movimiento'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_wasModified);
            },
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'completar':
                    _confirmCompletar(context);
                    break;
                  case 'cancelar':
                    _confirmCancelar(context);
                    break;
                }
              },
              itemBuilder: (context) {
                final state = context.read<MovimientoBloc>().state;
                if (state is MovimientoLoaded) {
                  final movimiento = state.movimiento;
                  
                  return [
                    if (!movimiento.isCompletado && !movimiento.isCancelado)
                      const PopupMenuItem<String>(
                        value: 'completar',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Completar'),
                          ],
                        ),
                      ),
                    if (movimiento.canBeCancelled)
                      const PopupMenuItem<String>(
                        value: 'cancelar',
                        child: Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Cancelar'),
                          ],
                        ),
                      ),
                  ];
                }
                return [];
              },
            ),
          ],
        ),
        body: BlocConsumer<MovimientoBloc, MovimientoState>(
          listener: (context, state) {
            if (state is MovimientoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is MovimientoOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Operación exitosa'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                _wasModified = true;
              });
              // Reload movimiento
              context.read<MovimientoBloc>().add(LoadMovimientoById(widget.movimientoId));
            }
          },
          builder: (context, state) {
            if (state is MovimientoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MovimientoLoaded) {
              final movimiento = state.movimiento;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, movimiento),
                    const SizedBox(height: 24),
                    _buildInfoSection(context, movimiento),
                    const SizedBox(height: 16),
                    _buildCantidadSection(context, movimiento),
                    const SizedBox(height: 16),
                    if (movimiento.costoTotal > 0) ...[
                      _buildCostosSection(context, movimiento),
                      const SizedBox(height: 16),
                    ],
                    if (movimiento.tiendaOrigenId != null || movimiento.tiendaDestinoId != null) ...[
                      _buildTiendasSection(context, movimiento),
                      const SizedBox(height: 16),
                    ],
                    if (movimiento.numeroFactura != null ||
                        movimiento.numeroGuiaRemision != null ||
                        movimiento.vehiculoPlaca != null ||
                        movimiento.conductor != null) ...[
                      _buildDocumentosSection(context, movimiento),
                      const SizedBox(height: 16),
                    ],
                    if (movimiento.observaciones != null && movimiento.observaciones!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Observaciones'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(movimiento.observaciones!),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildSectionTitle(context, 'Fechas de Sistema'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Fecha de Movimiento', _formatDate(movimiento.fechaMovimiento)),
                      _buildInfoRow('Fecha de Creación', _formatDate(movimiento.createdAt)),
                      _buildInfoRow('Última Actualización', _formatDate(movimiento.updatedAt)),
                    ]),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('No se pudo cargar el movimiento'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Movimiento movimiento) {
    Color statusColor = _getStatusColor(movimiento.estado);
    IconData tipoIcon = _getTipoIcon(movimiento.tipo);

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: statusColor,
                  child: Icon(tipoIcon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movimiento.numeroMovimiento,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          movimiento.estado,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    movimiento.tipo,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Movimiento movimiento) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Información General'),
        _buildInfoCard(context, [
          _buildInfoRow('Número de Movimiento', movimiento.numeroMovimiento),
          _buildInfoRow('Tipo', movimiento.tipo),
          _buildInfoRow('Estado', movimiento.estado),
          if (movimiento.motivo != null)
            _buildInfoRow('Motivo', movimiento.motivo!),
        ]),
      ],
    );
  }

  Widget _buildCantidadSection(BuildContext context, Movimiento movimiento) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Cantidad'),
        _buildInfoCard(context, [
          _buildInfoRow('Cantidad', '${movimiento.cantidad}'),
          if (movimiento.pesoTotalKg != null)
            _buildInfoRow('Peso Total', '${movimiento.pesoTotalKg} kg'),
        ]),
      ],
    );
  }

  Widget _buildCostosSection(BuildContext context, Movimiento movimiento) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Costos'),
        _buildInfoCard(context, [
          _buildInfoRow('Costo Unitario', '\$${movimiento.costoUnitario.toStringAsFixed(2)}'),
          _buildInfoRow(
            'Costo Total',
            '\$${movimiento.costoTotal.toStringAsFixed(2)}',
            valueColor: Colors.green,
          ),
        ]),
      ],
    );
  }

  Widget _buildTiendasSection(BuildContext context, Movimiento movimiento) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Tiendas'),
        _buildInfoCard(context, [
          if (movimiento.tiendaOrigenId != null)
            _buildInfoRow('Tienda Origen', movimiento.tiendaOrigenId!),
          if (movimiento.tiendaDestinoId != null)
            _buildInfoRow('Tienda Destino', movimiento.tiendaDestinoId!),
        ]),
      ],
    );
  }

  Widget _buildDocumentosSection(BuildContext context, Movimiento movimiento) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Documentos y Transporte'),
        _buildInfoCard(context, [
          if (movimiento.numeroFactura != null)
            _buildInfoRow('Número de Factura', movimiento.numeroFactura!),
          if (movimiento.numeroGuiaRemision != null)
            _buildInfoRow('Guía de Remisión', movimiento.numeroGuiaRemision!),
          if (movimiento.vehiculoPlaca != null)
            _buildInfoRow('Vehículo', movimiento.vehiculoPlaca!),
          if (movimiento.conductor != null)
            _buildInfoRow('Conductor', movimiento.conductor!),
        ]),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String estado) {
    switch (estado) {
      case 'PENDIENTE':
        return Colors.orange;
      case 'EN_TRANSITO':
        return Colors.blue;
      case 'COMPLETADO':
        return Colors.green;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo) {
      case 'COMPRA':
        return Icons.shopping_cart;
      case 'VENTA':
        return Icons.point_of_sale;
      case 'TRANSFERENCIA':
        return Icons.swap_horiz;
      case 'AJUSTE':
        return Icons.tune;
      case 'DEVOLUCION':
        return Icons.keyboard_return;
      case 'MERMA':
        return Icons.trending_down;
      default:
        return Icons.move_to_inbox;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _confirmCompletar(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Completar Movimiento'),
        content: const Text(
          '¿Está seguro de que desea completar este movimiento?\n\n'
          'Esta acción actualizará el inventario correspondiente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<MovimientoBloc>()
                  .add(CompletarMovimientoEvent(widget.movimientoId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Completar'),
          ),
        ],
      ),
    );
  }

  void _confirmCancelar(BuildContext context) {
    final motivoController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar Movimiento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿Está seguro de que desea cancelar este movimiento?\n\n'
              'Debe proporcionar un motivo de cancelación:',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: motivoController,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                hintText: 'Ingrese el motivo de cancelación',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              motivoController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final motivo = motivoController.text.trim();
              if (motivo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Debe ingresar un motivo'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              
              Navigator.pop(dialogContext);
              context.read<MovimientoBloc>().add(
                    CancelarMovimientoEvent(
                      id: widget.movimientoId,
                      motivo: motivo,
                    ),
                  );
              motivoController.dispose();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cancelar Movimiento'),
          ),
        ],
      ),
    );
  }
}
