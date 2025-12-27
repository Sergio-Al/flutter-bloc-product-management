import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/permissions/permission_helper.dart';
import '../../blocs/almacen/almacen_bloc.dart';
import '../../blocs/almacen/almacen_event.dart';
import '../../blocs/almacen/almacen_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import 'almacen_form_page.dart';

class AlmacenDetailPage extends StatefulWidget {
  final String almacenId;

  const AlmacenDetailPage({Key? key, required this.almacenId})
    : super(key: key);

  @override
  State<AlmacenDetailPage> createState() => _AlmacenDetailPageState();
}

class _AlmacenDetailPageState extends State<AlmacenDetailPage> {
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
          title: const Text('Detalle del Almacén'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_wasModified);
            },
          ),
          actions: _buildAppBarActions(context),
        ),
        body: BlocConsumer<AlmacenBloc, AlmacenState>(
          listener: (context, state) {
            if (state is AlmacenError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is AlmacenOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Return true to indicate almacen was modified (deleted)
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            if (state is AlmacenLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AlmacenDetailLoaded) {
              final almacen = state.almacen;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Card(
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              almacen.nombre,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    almacen.codigo,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getTipoColor(almacen.tipo),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getTipoIcon(almacen.tipo),
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        almacen.tipo,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  almacen.activo
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: almacen.activo
                                      ? Colors.lightGreen
                                      : Colors.redAccent,
                                  size: 32,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Information Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(context, 'Información General'),
                          _buildInfoCard(context, [
                            _buildInfoRow(
                              Icons.location_on,
                              'Ubicación',
                              almacen.ubicacion,
                            ),
                            if (almacen.capacidadM3 != null)
                              _buildInfoRow(
                                Icons.inventory,
                                'Capacidad',
                                '${almacen.capacidadM3!.toStringAsFixed(2)} m³',
                              ),
                            if (almacen.areaM2 != null)
                              _buildInfoRow(
                                Icons.square_foot,
                                'Área',
                                '${almacen.areaM2!.toStringAsFixed(2)} m²',
                              ),
                            _buildInfoRow(
                              Icons.info,
                              'Estado',
                              almacen.activo ? 'Activo' : 'Inactivo',
                              valueColor: almacen.activo
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ]),
                          const SizedBox(height: 24),

                          // Characteristics Section
                          if (almacen.isPrincipal)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(context, 'Características'),
                                _buildInfoCard(context, [
                                  _buildInfoRow(
                                    Icons.star,
                                    'Tipo',
                                    'Almacén Principal',
                                    valueColor: Colors.blue,
                                  ),
                                ]),
                                const SizedBox(height: 24),
                              ],
                            ),

                          // Timestamps Section
                          _buildSectionTitle(context, 'Registro'),
                          _buildInfoCard(context, [
                            _buildInfoRow(
                              Icons.access_time,
                              'Creado',
                              _formatDateTime(almacen.createdAt),
                            ),
                            _buildInfoRow(
                              Icons.update,
                              'Actualizado',
                              _formatDateTime(almacen.updatedAt),
                            ),
                            if (almacen.deletedAt != null)
                              _buildInfoRow(
                                Icons.delete_outline,
                                'Eliminado',
                                _formatDateTime(almacen.deletedAt!),
                                valueColor: Colors.red,
                              ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No se pudo cargar el almacén'));
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTipoColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'principal':
        return Colors.blue;
      case 'obra':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'principal':
        return Icons.home_work;
      case 'obra':
        return Icons.construction;
      default:
        return Icons.local_shipping;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToEdit(BuildContext context) async {
    final state = context.read<AlmacenBloc>().state;
    if (state is AlmacenDetailLoaded) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AlmacenBloc>(),
            child: AlmacenFormPage(almacen: state.almacen),
          ),
        ),
      );

      // If almacen was updated, reload the detail and mark as modified
      if (result == true && mounted) {
        setState(() {
          _wasModified = true;
        });
        context.read<AlmacenBloc>().add(LoadAlmacenById(id: widget.almacenId));
      }
    }
  }

  /// Build AppBar actions with permission checks
  /// Edit: Gerente (full) and Almacenero (partial)
  /// Delete: No one can delete almacenes
  List<Widget> _buildAppBarActions(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.rolNombre;
    }

    final actions = <Widget>[];

    // Edit button - Gerente and Almacenero can edit
    if (PermissionHelper.canEditAlmacen(userRole)) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _navigateToEdit(context),
          tooltip: 'Editar',
        ),
      );
    }

    // Delete button - No one can delete almacenes per PERMISOS.md
    // Intentionally removed - deletion is prohibited for all roles
    //
    // ═══════════════════════════════════════════════════════════════════════════
    // TO RESTORE DELETE FUNCTIONALITY:
    // 1. Add canDeleteAlmacen to PermissionHelper (already exists, returns false)
    // 2. Modify canDeleteAlmacen to return true for desired roles
    // 3. Uncomment the block below
    // 4. Uncomment _confirmDelete method at the bottom of this file
    // ═══════════════════════════════════════════════════════════════════════════
    // if (PermissionHelper.canDeleteAlmacen(userRole)) {
    //   actions.add(
    //     IconButton(
    //       icon: const Icon(Icons.delete),
    //       onPressed: () => _confirmDelete(context),
    //       tooltip: 'Eliminar',
    //     ),
    //   );
    // }

    return actions;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESTORE DELETE: Uncomment this method to enable delete functionality
  // ═══════════════════════════════════════════════════════════════════════════
  // void _confirmDelete(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) => AlertDialog(
  //       title: const Text('Confirmar eliminación'),
  //       content: const Text(
  //         '¿Está seguro de que desea eliminar este almacén?\n\n'
  //         'Esta acción no se puede deshacer.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(dialogContext),
  //           child: const Text('Cancelar'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(dialogContext);
  //             context.read<AlmacenBloc>().add(DeleteAlmacen(widget.almacenId));
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.red,
  //           ),
  //           child: const Text('Eliminar'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
