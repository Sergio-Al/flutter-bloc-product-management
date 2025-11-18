import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/proveedor.dart';
import '../../blocs/proveedor/proveedor_bloc.dart';
import '../../blocs/proveedor/proveedor_event.dart';
import '../../blocs/proveedor/proveedor_state.dart';
import 'proveedores_form_page.dart';

class ProveedorDetailPage extends StatefulWidget {
  final String proveedorId;

  const ProveedorDetailPage({
    Key? key,
    required this.proveedorId,
  }) : super(key: key);

  @override
  State<ProveedorDetailPage> createState() => _ProveedorDetailPageState();
}

class _ProveedorDetailPageState extends State<ProveedorDetailPage> {
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
          title: const Text('Detalle de Proveedor'),
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
        body: BlocConsumer<ProveedorBloc, ProveedorState>(
          listener: (context, state) {
            if (state is ProveedorError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is ProveedorOperationSuccess) {
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
            if (state is ProveedorLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProveedorLoaded && state.proveedores.isNotEmpty) {
              final proveedor = state.proveedores.first;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, proveedor),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Información General'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Razón Social', proveedor.razonSocial),
                      _buildInfoRow('NIT', proveedor.nit),
                      if (proveedor.nombreContacto != null)
                        _buildInfoRow('Contacto', proveedor.nombreContacto!),
                      if (proveedor.tipoMaterial != null)
                        _buildInfoRow('Tipo Material', proveedor.tipoMaterial!),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Ubicación'),
                    _buildInfoCard(context, [
                      _buildInfoRow(
                        'Dirección',
                        proveedor.direccion ?? 'N/A',
                      ),
                      _buildInfoRow('Ciudad', proveedor.ciudad ?? 'N/A'),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Contacto'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Teléfono', proveedor.telefono ?? 'N/A'),
                      _buildInfoRow('Email', proveedor.email ?? 'N/A'),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Términos de Pago'),
                    _buildInfoCard(context, [
                      _buildInfoRow(
                        'Días de Crédito',
                        '${proveedor.diasCredito}',
                        valueColor: proveedor.offersCredit
                            ? Colors.green
                            : Colors.grey,
                      ),
                      _buildInfoRow(
                        'Condición',
                        proveedor.paymentTerms,
                        valueColor: proveedor.offersCredit
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Estado'),
                    _buildInfoCard(context, [
                      _buildInfoRow(
                        'Estado',
                        proveedor.activo ? 'Activo' : 'Inactivo',
                        valueColor:
                            proveedor.activo ? Colors.green : Colors.red,
                      ),
                      _buildInfoRow(
                        'Fecha de Creación',
                        _formatDate(proveedor.createdAt),
                      ),
                      _buildInfoRow(
                        'Última Actualización',
                        _formatDate(proveedor.updatedAt),
                      ),
                    ]),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('No se pudo cargar el proveedor'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Proveedor proveedor) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                proveedor.razonSocial[0].toUpperCase(),
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proveedor.razonSocial,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIT: ${proveedor.nit}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (proveedor.tipoMaterial != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      proveedor.tipoMaterial!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              proveedor.activo ? Icons.check_circle : Icons.cancel,
              color: proveedor.activo ? Colors.green : Colors.red,
              size: 32,
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
    final state = context.read<ProveedorBloc>().state;
    if (state is ProveedorLoaded && state.proveedores.isNotEmpty) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProveedorBloc>(),
            child: ProveedoresFormPage(proveedor: state.proveedores.first),
          ),
        ),
      );

      if (result == true && mounted) {
        setState(() {
          _wasModified = true;
        });
        context
            .read<ProveedorBloc>()
            .add(LoadProveedorById(widget.proveedorId));
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
          '¿Está seguro de que desea eliminar este proveedor?\n\n'
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
                  .read<ProveedorBloc>()
                  .add(DeleteProveedor(widget.proveedorId));
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
