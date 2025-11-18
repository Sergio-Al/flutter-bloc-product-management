import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/tienda.dart';
import '../../blocs/tienda/tienda_bloc.dart';
import '../../blocs/tienda/tienda_event.dart';
import '../../blocs/tienda/tienda_state.dart';

class TiendaFormPage extends StatefulWidget {
  final Tienda? tienda;

  const TiendaFormPage({Key? key, this.tienda}) : super(key: key);

  @override
  State<TiendaFormPage> createState() => _TiendaFormPageState();
}

class _TiendaFormPageState extends State<TiendaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoController;
  late final TextEditingController _nombreController;
  late final TextEditingController _razonSocialController;
  late final TextEditingController _nitController;
  late final TextEditingController _direccionController;
  late final TextEditingController _ciudadController;
  late final TextEditingController _departamentoController;
  late final TextEditingController _zonaController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _emailController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.tienda != null;

    _codigoController = TextEditingController(
      text: widget.tienda?.codigo ?? '',
    );
    _nombreController = TextEditingController(
      text: widget.tienda?.nombre ?? '',
    );
    // _razonSocialController = TextEditingController(text: widget.tienda?.razonSocial ?? '');
    // _nitController = TextEditingController(text: widget.tienda?.nit ?? '');
    _direccionController = TextEditingController(
      text: widget.tienda?.direccion ?? '',
    );
    _ciudadController = TextEditingController(
      text: widget.tienda?.ciudad ?? '',
    );
    _departamentoController = TextEditingController(
      text: widget.tienda?.departamento ?? '',
    );
    // _zonaController = TextEditingController(text: widget.tienda?.zona ?? '');
    _telefonoController = TextEditingController(
      text: widget.tienda?.telefono ?? '',
    );
    // _emailController = TextEditingController(text: widget.tienda?.email ?? '');
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    // _razonSocialController.dispose();
    // _nitController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _departamentoController.dispose();
    // _zonaController.dispose();
    _telefonoController.dispose();
    // _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Tienda' : 'Nueva Tienda'),
      ),
      body: BlocConsumer<TiendaBloc, TiendaState>(
        listener: (context, state) {
          if (state is TiendaOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
          if (state is TiendaOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is TiendaLoading;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle('Información Básica'),
                TextFormField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código *',
                    hintText: 'Ej: TDA-001',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El código es requerido';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre *',
                    hintText: 'Nombre de la tienda',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                // TextFormField(
                //   controller: _razonSocialController,
                //   decoration: const InputDecoration(
                //     labelText: 'Razón Social',
                //     border: OutlineInputBorder(),
                //   ),
                //   enabled: !isLoading,
                // ),
                // const SizedBox(height: 16),
                // TextFormField(
                //   controller: _nitController,
                //   decoration: const InputDecoration(
                //     labelText: 'NIT',
                //     border: OutlineInputBorder(),
                //   ),
                //   keyboardType: TextInputType.number,
                //   enabled: !isLoading,
                // ),
                // const SizedBox(height: 24),
                _buildSectionTitle('Ubicación'),
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección *',
                    hintText: 'Dirección completa',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La dirección es requerida';
                    }
                    return null;
                  },
                  maxLines: 2,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ciudadController,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La ciudad es requerida';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _departamentoController,
                  decoration: const InputDecoration(
                    labelText: 'Departamento *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El departamento es requerido';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                // TextFormField(
                //   controller: _zonaController,
                //   decoration: const InputDecoration(
                //     labelText: 'Zona',
                //     hintText: 'Ej: Zona Sur',
                //     border: OutlineInputBorder(),
                //   ),
                //   enabled: !isLoading,
                // ),
                // const SizedBox(height: 24),
                _buildSectionTitle('Contacto'),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                // TextFormField(
                //   controller: _emailController,
                //   decoration: const InputDecoration(
                //     labelText: 'Email',
                //     border: OutlineInputBorder(),
                //   ),
                //   keyboardType: TextInputType.emailAddress,
                //   validator: (value) {
                //     if (value != null && value.isNotEmpty) {
                //       final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                //       if (!emailRegex.hasMatch(value)) {
                //         return 'Email inválido';
                //       }
                //     }
                //     return null;
                //   },
                //   enabled: !isLoading,
                // ),
                // const SizedBox(height: 32),
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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tiendaData = Tienda(
      id: _isEditing ? widget.tienda!.id : const Uuid().v4(),
      codigo: _codigoController.text.trim(),
      nombre: _nombreController.text.trim(),
      // razonSocial: _razonSocialController.text.trim().isEmpty
      //     ? null
      //     : _razonSocialController.text.trim(),
      // nit: _nitController.text.trim().isEmpty ? null : _nitController.text.trim(),
      direccion: _direccionController.text.trim(),
      ciudad: _ciudadController.text.trim(),
      departamento: _departamentoController.text.trim(),
      // zona: _zonaController.text.trim().isEmpty ? null : _zonaController.text.trim(),
      telefono: _telefonoController.text.trim().isEmpty
          ? null
          : _telefonoController.text.trim(),
      // email: _emailController.text.trim().isEmpty
      //     ? null
      //     : _emailController.text.trim(),
      activo: _isEditing ? widget.tienda!.activo : true,
      createdAt: _isEditing ? widget.tienda!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      context.read<TiendaBloc>().add(
        UpdateTienda(id: widget.tienda!.id, tiendaData: tiendaData),
      );
    } else {
      context.read<TiendaBloc>().add(CreateTienda(tiendaData: tiendaData));
    }
  }
}
