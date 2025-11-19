import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/inventario.dart';
import '../../blocs/inventario/inventario_bloc.dart';
import '../../blocs/inventario/inventario_event.dart';
import '../../blocs/inventario/inventario_state.dart';
import 'inventario_form_page.dart';
import 'ajuste_inventario_page.dart';

class InventarioDetailPage extends StatefulWidget {
  final String inventarioId;

  const InventarioDetailPage({
    Key? key,
    required this.inventarioId,
  }) : super(key: key);

  @override
  State<InventarioDetailPage> createState() => _InventarioDetailPageState();
}

class _InventarioDetailPageState extends State<InventarioDetailPage> {
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
          title: const Text('Detalle de Inventario'),
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
              icon: const Icon(Icons.tune),
              onPressed: () => _navigateToAjuste(context),
              tooltip: 'Ajustar Stock',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
              tooltip: 'Eliminar',
            ),
          ],
        ),
        body: BlocConsumer<InventarioBloc, InventarioState>(
          listener: (context, state) {
            if (state is InventarioError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is InventarioOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Operación exitosa'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            if (state is InventarioLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is InventarioLoaded) {
              final inventario = state.inventario;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, inventario),
                    const SizedBox(height: 24),
                    _buildStockSection(context, inventario),
                    const SizedBox(height: 16),
                    _buildQuickActions(context, inventario),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Información de Stock'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Stock Actual', '${inventario.cantidadActual}'),
                      _buildInfoRow('Stock Disponible', '${inventario.cantidadDisponible}',
                          valueColor: inventario.cantidadDisponible > 0 ? Colors.green : Colors.red),
                      _buildInfoRow('Stock Reservado', '${inventario.cantidadReservada}',
                          valueColor: inventario.cantidadReservada > 0 ? Colors.blue : null),
                      if (inventario.cantidadReservada > 0)
                        _buildInfoRow('% Reservado', '${inventario.reservationPercentage.toStringAsFixed(1)}%',
                            valueColor: Colors.blue),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Valor'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Valor Total', '\$${inventario.valorTotal.toStringAsFixed(2)}',
                          valueColor: Colors.green),
                      _buildInfoRow('Valor Unitario', '\$${inventario.valorUnitario.toStringAsFixed(2)}'),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Ubicación'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Ubicación Física',
                          inventario.ubicacionFisica ?? 'No especificada',
                          valueColor: inventario.hasUbicacionFisica ? null : Colors.orange),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Fechas'),
                    _buildInfoCard(context, [
                      if (inventario.ultimaActualizacion != null)
                        _buildInfoRow('Última Actualización',
                            _formatDate(inventario.ultimaActualizacion!)),
                      _buildInfoRow('Fecha de Creación', _formatDate(inventario.createdAt)),
                      _buildInfoRow('Última Modificación', _formatDate(inventario.updatedAt)),
                    ]),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('No se pudo cargar el inventario'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Inventario inventario) {
    Color statusColor = Colors.green;
    IconData statusIcon = Icons.check_circle;
    String statusText = 'Disponible';

    if (inventario.isEmpty) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'Vacío';
    } else if (inventario.cantidadDisponible < (inventario.cantidadActual * 0.2)) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
      statusText = 'Stock bajo';
    } else if (inventario.isFullyReserved) {
      statusColor = Colors.blue;
      statusIcon = Icons.lock;
      statusText = 'Totalmente Reservado';
    }

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: statusColor,
              child: Icon(statusIcon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inventario.ubicacionFisica ?? 'Sin ubicación',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Disponible: ${inventario.cantidadDisponible}/${inventario.cantidadActual}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSection(BuildContext context, Inventario inventario) {
    final disponiblePorcentaje = inventario.cantidadActual > 0
        ? inventario.cantidadDisponible / inventario.cantidadActual
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado del Stock',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Disponible', style: Theme.of(context).textTheme.bodySmall),
                      LinearProgressIndicator(
                        value: disponiblePorcentaje,
                        minHeight: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          disponiblePorcentaje > 0.5
                              ? Colors.green
                              : disponiblePorcentaje > 0.2
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(disponiblePorcentaje * 100).toStringAsFixed(1)}% disponible',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (inventario.cantidadReservada > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reservado', style: Theme.of(context).textTheme.bodySmall),
                        LinearProgressIndicator(
                          value: inventario.reservationPercentage / 100,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${inventario.reservationPercentage.toStringAsFixed(1)}% reservado',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Inventario inventario) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showReservarDialog(context, inventario),
              icon: const Icon(Icons.lock, size: 16),
              label: const Text('Reservar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            if (inventario.cantidadReservada > 0)
              ElevatedButton.icon(
                onPressed: () => _showLiberarDialog(context, inventario),
                icon: const Icon(Icons.lock_open, size: 16),
                label: const Text('Liberar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ElevatedButton.icon(
              onPressed: () => _navigateToAjuste(context),
              icon: const Icon(Icons.tune, size: 16),
              label: const Text('Ajustar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _navigateToEdit(BuildContext context) async {
    final state = context.read<InventarioBloc>().state;
    if (state is InventarioLoaded) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<InventarioBloc>(),
            child: InventarioFormPage(inventario: state.inventario),
          ),
        ),
      );

      if (result == true && mounted) {
        setState(() {
          _wasModified = true;
        });
        context.read<InventarioBloc>().add(LoadInventarioById(widget.inventarioId));
      }
    }
  }

  void _navigateToAjuste(BuildContext context) async {
    final state = context.read<InventarioBloc>().state;
    if (state is InventarioLoaded) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<InventarioBloc>(),
            child: AjusteInventarioPage(inventario: state.inventario),
          ),
        ),
      );

      if (result == true && mounted) {
        setState(() {
          _wasModified = true;
        });
        context.read<InventarioBloc>().add(LoadInventarioById(widget.inventarioId));
      }
    }
  }

  void _showReservarDialog(BuildContext context, Inventario inventario) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reservar Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Disponible: ${inventario.cantidadDisponible}'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Cantidad a reservar',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final cantidad = int.tryParse(controller.text);
              if (cantidad != null && cantidad > 0 && cantidad <= inventario.cantidadDisponible) {
                Navigator.pop(dialogContext);
                context.read<InventarioBloc>().add(
                      ReservarStockInventario(
                        inventarioId: inventario.id,
                        cantidad: cantidad,
                      ),
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cantidad inválida'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Reservar'),
          ),
        ],
      ),
    );
  }

  void _showLiberarDialog(BuildContext context, Inventario inventario) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Liberar Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reservado: ${inventario.cantidadReservada}'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Cantidad a liberar',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final cantidad = int.tryParse(controller.text);
              if (cantidad != null && cantidad > 0 && cantidad <= inventario.cantidadReservada) {
                Navigator.pop(dialogContext);
                context.read<InventarioBloc>().add(
                      LiberarStockInventario(
                        inventarioId: inventario.id,
                        cantidad: cantidad,
                      ),
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cantidad inválida'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Liberar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
          '¿Está seguro de que desea eliminar este registro de inventario?\n\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<InventarioBloc>().add(DeleteInventario(widget.inventarioId));
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
