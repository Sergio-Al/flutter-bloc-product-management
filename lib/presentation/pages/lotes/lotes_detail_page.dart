import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/lote.dart';
import '../../blocs/lote/lote_bloc.dart';
import '../../blocs/lote/lote_event.dart';
import '../../blocs/lote/lote_state.dart';
import 'lotes_form_page.dart';

class LoteDetailPage extends StatefulWidget {
  final String loteId;

  const LoteDetailPage({
    Key? key,
    required this.loteId,
  }) : super(key: key);

  @override
  State<LoteDetailPage> createState() => _LoteDetailPageState();
}

class _LoteDetailPageState extends State<LoteDetailPage> {
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
          title: const Text('Detalle de Lote'),
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
              onPressed: () => _confirmDelete(context),
              tooltip: 'Eliminar',
            ),
          ],
        ),
        body: BlocConsumer<LoteBloc, LoteState>(
          listener: (context, state) {
            if (state is LoteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is LoteOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            if (state is LoteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LoteLoaded && state.lotes.isNotEmpty) {
              final lote = state.lotes.first;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, lote),
                    const SizedBox(height: 24),
                    _buildStockSection(context, lote),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Información General'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Número de Lote', lote.numeroLote),
                      if (lote.numeroFactura != null)
                        _buildInfoRow('Factura', lote.numeroFactura!),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Fechas'),
                    _buildInfoCard(context, [
                      if (lote.fechaFabricacion != null)
                        _buildInfoRow(
                          'Fabricación',
                          _formatDate(lote.fechaFabricacion!),
                        ),
                      if (lote.fechaVencimiento != null)
                        _buildInfoRow(
                          'Vencimiento',
                          _formatDate(lote.fechaVencimiento!),
                          valueColor: lote.isExpired
                              ? Colors.red
                              : lote.isNearExpiration
                                  ? Colors.orange
                                  : null,
                        ),
                      if (lote.daysUntilExpiration != null)
                        _buildInfoRow(
                          'Días hasta vencimiento',
                          '${lote.daysUntilExpiration} días',
                          valueColor: lote.isExpired
                              ? Colors.red
                              : lote.isNearExpiration
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Cantidad'),
                    _buildInfoCard(context, [
                      _buildInfoRow(
                        'Cantidad Inicial',
                        '${lote.cantidadInicial}',
                      ),
                      _buildInfoRow(
                        'Cantidad Actual',
                        '${lote.cantidadActual}',
                        valueColor: lote.isEmpty
                            ? Colors.red
                            : Colors.green,
                      ),
                      _buildInfoRow(
                        'Uso',
                        '${lote.usagePercentage.toStringAsFixed(1)}%',
                      ),
                    ]),
                    const SizedBox(height: 16),
                    if (lote.hasCertificate) ...[
                      _buildSectionTitle(context, 'Certificado'),
                      _buildInfoCard(context, [
                        _buildInfoRow(
                          'Certificado de Calidad',
                          'Disponible',
                          valueColor: Colors.blue,
                        ),
                        if (lote.certificadoCalidadUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Open certificate URL
                              },
                              icon: const Icon(Icons.open_in_new),
                              label: const Text('Ver Certificado'),
                            ),
                          ),
                      ]),
                      const SizedBox(height: 16),
                    ],
                    if (lote.observaciones != null &&
                        lote.observaciones!.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Observaciones'),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(lote.observaciones!),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildSectionTitle(context, 'Fechas de Sistema'),
                    _buildInfoCard(context, [
                      _buildInfoRow(
                        'Fecha de Creación',
                        _formatDate(lote.createdAt),
                      ),
                      _buildInfoRow(
                        'Última Actualización',
                        _formatDate(lote.updatedAt),
                      ),
                    ]),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('No se pudo cargar el lote'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Lote lote) {
    Color statusColor = Colors.green;
    IconData statusIcon = Icons.check_circle;
    String statusText = 'Disponible';

    if (lote.isExpired) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'Vencido';
    } else if (lote.isNearExpiration) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
      statusText = 'Por vencer';
    } else if (lote.isEmpty) {
      statusColor = Colors.grey;
      statusIcon = Icons.inventory_2;
      statusText = 'Vacío';
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
                    lote.numeroLote,
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
                    'Stock: ${lote.cantidadActual}/${lote.cantidadInicial}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (lote.hasCertificate)
              const Icon(
                Icons.verified,
                color: Colors.blue,
                size: 32,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSection(BuildContext context, Lote lote) {
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
            LinearProgressIndicator(
              value: lote.cantidadInicial > 0
                  ? lote.cantidadActual / lote.cantidadInicial
                  : 0,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                lote.isEmpty
                    ? Colors.red
                    : lote.cantidadActual < (lote.cantidadInicial * 0.2)
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${lote.usagePercentage.toStringAsFixed(1)}% utilizado',
              style: Theme.of(context).textTheme.bodySmall,
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
    final state = context.read<LoteBloc>().state;
    if (state is LoteLoaded && state.lotes.isNotEmpty) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoteBloc>(),
            child: LotesFormPage(lote: state.lotes.first),
          ),
        ),
      );

      if (result == true && mounted) {
        setState(() {
          _wasModified = true;
        });
        context
            .read<LoteBloc>()
            .add(LoadLoteById(widget.loteId));
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
          '¿Está seguro de que desea eliminar este lote?\n\n'
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
              context
                  .read<LoteBloc>()
                  .add(DeleteLote(widget.loteId));
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
