import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/proveedor.dart';
import '../../blocs/proveedor/proveedor_bloc.dart';
import '../../blocs/proveedor/proveedor_event.dart';
import '../../blocs/proveedor/proveedor_state.dart';

class ProveedoresFormPage extends StatefulWidget {
  final Proveedor? proveedor;

  const ProveedoresFormPage({Key? key, this.proveedor}) : super(key: key);

  @override
  State<ProveedoresFormPage> createState() => _ProveedoresFormPageState();
}

class _ProveedoresFormPageState extends State<ProveedoresFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _razonSocialController;
  late final TextEditingController _nitController;
  late final TextEditingController _nombreContactoController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _emailController;
  late final TextEditingController _direccionController;
  late final TextEditingController _ciudadController;
  late final TextEditingController _tipoMaterialController;
  late final TextEditingController _diasCreditoController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.proveedor != null;

    _razonSocialController = TextEditingController(
      text: widget.proveedor?.razonSocial ?? '',
    );
    _nitController = TextEditingController(
      text: widget.proveedor?.nit ?? '',
    );
    _nombreContactoController = TextEditingController(
      text: widget.proveedor?.nombreContacto ?? '',
    );
    _telefonoController = TextEditingController(
      text: widget.proveedor?.telefono ?? '',
    );
    _emailController = TextEditingController(
      text: widget.proveedor?.email ?? '',
    );
    _direccionController = TextEditingController(
      text: widget.proveedor?.direccion ?? '',
    );
    _ciudadController = TextEditingController(
      text: widget.proveedor?.ciudad ?? '',
    );
    _tipoMaterialController = TextEditingController(
      text: widget.proveedor?.tipoMaterial ?? '',
    );
    _diasCreditoController = TextEditingController(
      text: widget.proveedor?.diasCredito.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _razonSocialController.dispose();
    _nitController.dispose();
    _nombreContactoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _tipoMaterialController.dispose();
    _diasCreditoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Proveedor' : 'Nuevo Proveedor'),
      ),
      body: BlocConsumer<ProveedorBloc, ProveedorState>(
        listener: (context, state) {
          if (state is ProveedorOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
          if (state is ProveedorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProveedorLoading;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle('Información Básica'),
                TextFormField(
                  controller: _razonSocialController,
                  decoration: const InputDecoration(
                    labelText: 'Razón Social *',
                    hintText: 'Nombre comercial del proveedor',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La razón social es requerida';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nitController,
                  decoration: const InputDecoration(
                    labelText: 'NIT *',
                    hintText: 'Número de identificación tributaria',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El NIT es requerido';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nombreContactoController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Contacto',
                    hintText: 'Persona de contacto',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tipoMaterialController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Material',
                    hintText: 'Ej: Cemento, Hierro, Madera',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Ubicación'),
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    hintText: 'Dirección completa',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 2,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ciudadController,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Contacto'),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Email inválido';
                      }
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Términos de Pago'),
                TextFormField(
                  controller: _diasCreditoController,
                  decoration: const InputDecoration(
                    labelText: 'Días de Crédito *',
                    hintText: '0 para pago de contado',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixText: 'días',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Los días de crédito son requeridos';
                    }
                    final dias = int.tryParse(value);
                    if (dias == null || dias < 0) {
                      return 'Ingrese un número válido';
                    }
                    return null;
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingrese 0 para pago de contado, o el número de días para crédito',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 32),
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

    final proveedorData = Proveedor(
      id: _isEditing ? widget.proveedor!.id : const Uuid().v4(),
      razonSocial: _razonSocialController.text.trim(),
      nit: _nitController.text.trim(),
      nombreContacto: _nombreContactoController.text.trim().isEmpty
          ? null
          : _nombreContactoController.text.trim(),
      telefono: _telefonoController.text.trim().isEmpty
          ? null
          : _telefonoController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      direccion: _direccionController.text.trim().isEmpty
          ? null
          : _direccionController.text.trim(),
      ciudad: _ciudadController.text.trim().isEmpty
          ? null
          : _ciudadController.text.trim(),
      tipoMaterial: _tipoMaterialController.text.trim().isEmpty
          ? null
          : _tipoMaterialController.text.trim(),
      diasCredito: int.parse(_diasCreditoController.text.trim()),
      activo: _isEditing ? widget.proveedor!.activo : true,
      createdAt: _isEditing ? widget.proveedor!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      context.read<ProveedorBloc>().add(UpdateProveedor(proveedorData));
    } else {
      context.read<ProveedorBloc>().add(CreateProveedor(proveedorData));
    }
  }
}
