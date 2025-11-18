import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/tienda.dart';
import '../../blocs/tienda/tienda_bloc.dart';
import '../../blocs/tienda/tienda_event.dart';
import '../../blocs/tienda/tienda_state.dart';
import 'tienda_form_page.dart';

class TiendaDetailPage extends StatefulWidget {
  final String tiendaId;

  const TiendaDetailPage({
    Key? key,
    required this.tiendaId,
  }) : super(key: key);

  @override
  State<TiendaDetailPage> createState() => _TiendaDetailPageState();
}

class _TiendaDetailPageState extends State<TiendaDetailPage> {
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
          title: const Text('Detalle de Tienda'),
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
        body: BlocConsumer<TiendaBloc, TiendaState>(
          listener: (context, state) {
            if (state is TiendaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is TiendaOperationSuccess) {
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
            if (state is TiendaLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TiendaLoaded && state.tiendas.isNotEmpty) {
              final tienda = state.tiendas.first;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, tienda),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Información General'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Código', tienda.codigo),
                      _buildInfoRow('Nombre', tienda.nombre),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Ubicación'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Dirección', tienda.direccion ?? 'N/A'),
                      _buildInfoRow('Ciudad', tienda.ciudad ?? 'N/A'),
                      _buildInfoRow('Departamento', tienda.departamento ?? 'N/A'),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Contacto'),
                    _buildInfoCard(context, [
                      _buildInfoRow('Teléfono', tienda.telefono ?? 'N/A'),
                      _buildInfoRow('Horario', tienda.horarioAtencion ?? 'N/A'),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle(context, 'Estado'),
                    _buildInfoCard(context, [
                      _buildInfoRow(
                        'Estado',
                        tienda.activo ? 'Activa' : 'Inactiva',
                        valueColor: tienda.activo ? Colors.green : Colors.red,
                      ),
                      _buildInfoRow(
                        'Fecha de Creación',
                        _formatDate(tienda.createdAt),
                      ),
                      if (tienda.updatedAt != null)
                        _buildInfoRow(
                          'Última Actualización',
                          _formatDate(tienda.updatedAt!),
                        ),
                    ]),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('No se pudo cargar la tienda'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Tienda tienda) {
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
                tienda.nombre[0].toUpperCase(),
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tienda.nombre,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tienda.codigo,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              tienda.activo ? Icons.check_circle : Icons.cancel,
              color: tienda.activo ? Colors.green : Colors.red,
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
    final state = context.read<TiendaBloc>().state;
    if (state is TiendaLoaded && state.tiendas.isNotEmpty) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<TiendaBloc>(),
            child: TiendaFormPage(tienda: state.tiendas.first),
          ),
        ),
      );

      if (result == true && mounted) {
        setState(() {
          _wasModified = true;
        });
        context.read<TiendaBloc>().add(LoadTiendaById(id: widget.tiendaId));
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
          '¿Está seguro de que desea eliminar esta tienda?\n\n'
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
              context.read<TiendaBloc>().add(DeleteTienda(id: widget.tiendaId));
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
