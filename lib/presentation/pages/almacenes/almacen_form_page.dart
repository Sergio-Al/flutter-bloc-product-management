import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/almacen.dart';
import '../../blocs/almacen/almacen_bloc.dart';
import '../../blocs/almacen/almacen_event.dart';
import '../../blocs/almacen/almacen_state.dart';

class AlmacenFormPage extends StatefulWidget {
  final Almacen? almacen;

  const AlmacenFormPage({
    Key? key,
    this.almacen,
  }) : super(key: key);

  @override
  State<AlmacenFormPage> createState() => _AlmacenFormPageState();
}

class _AlmacenFormPageState extends State<AlmacenFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _codigoController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _capacidadController = TextEditingController();
  final _areaController = TextEditingController();
  
  String _selectedTipo = 'Principal';
  bool _activo = true;

  final List<String> _tiposAlmacen = ['Principal', 'Obra', 'Transito'];

  bool get _isEditing => widget.almacen != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadAlmacenData();
    }
  }

  void _loadAlmacenData() {
    final almacen = widget.almacen!;
    _nombreController.text = almacen.nombre;
    _codigoController.text = almacen.codigo;
    _ubicacionController.text = almacen.ubicacion;
    _selectedTipo = almacen.tipo;
    _activo = almacen.activo;
    
    if (almacen.capacidadM3 != null) {
      _capacidadController.text = almacen.capacidadM3!.toString();
    }
    if (almacen.areaM2 != null) {
      _areaController.text = almacen.areaM2!.toString();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoController.dispose();
    _ubicacionController.dispose();
    _capacidadController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Almacén' : 'Crear Almacén'),
      ),
      body: BlocConsumer<AlmacenBloc, AlmacenState>(
        listener: (context, state) {
          if (state is AlmacenOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Return true to indicate success
          }

          if (state is AlmacenOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AlmacenCreating || state is AlmacenUpdating;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Basic Information Section
                Text(
                  'Información Básica',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Nombre
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Almacén *',
                    hintText: 'Ej: Almacén Central',
                    prefixIcon: Icon(Icons.warehouse),
                    border: OutlineInputBorder(),
                  ),
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    if (value.trim().length < 3) {
                      return 'El nombre debe tener al menos 3 caracteres';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Codigo
                TextFormField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código *',
                    hintText: 'Ej: ALM-001',
                    prefixIcon: Icon(Icons.tag),
                    border: OutlineInputBorder(),
                  ),
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El código es requerido';
                    }
                    if (value.trim().length < 2) {
                      return 'El código debe tener al menos 2 caracteres';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),

                // Tipo
                DropdownButtonFormField<String>(
                  value: _selectedTipo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Almacén *',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: _tiposAlmacen.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Row(
                        children: [
                          Icon(_getTipoIcon(tipo), size: 20),
                          const SizedBox(width: 8),
                          Text(tipo),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: isLoading
                      ? null
                      : (value) {
                          setState(() => _selectedTipo = value!);
                        },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un tipo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Ubicacion
                TextFormField(
                  controller: _ubicacionController,
                  decoration: const InputDecoration(
                    labelText: 'Ubicación *',
                    hintText: 'Ej: Av. Principal 123',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La ubicación es requerida';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Physical Specifications Section
                Text(
                  'Especificaciones Físicas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Capacidad
                TextFormField(
                  controller: _capacidadController,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad (m³)',
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.inventory),
                    suffixText: 'm³',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !isLoading,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final capacidad = double.tryParse(value);
                      if (capacidad == null) {
                        return 'Ingrese un número válido';
                      }
                      if (capacidad < 0) {
                        return 'La capacidad no puede ser negativa';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Area
                TextFormField(
                  controller: _areaController,
                  decoration: const InputDecoration(
                    labelText: 'Área (m²)',
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.square_foot),
                    suffixText: 'm²',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !isLoading,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final area = double.tryParse(value);
                      if (area == null) {
                        return 'Ingrese un número válido';
                      }
                      if (area < 0) {
                        return 'El área no puede ser negativa';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Estado Section
                Text(
                  'Estado',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Activo Switch
                SwitchListTile(
                  title: const Text('Almacén activo'),
                  subtitle: Text(
                    _activo
                        ? 'El almacén está disponible para operaciones'
                        : 'El almacén está desactivado',
                  ),
                  value: _activo,
                  onChanged: isLoading
                      ? null
                      : (value) {
                          setState(() => _activo = value);
                        },
                  secondary: Icon(
                    _activo ? Icons.check_circle : Icons.cancel,
                    color: _activo ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
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
              ],
            ),
          );
        },
      ),
    );
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final almacen = Almacen(
        id: _isEditing ? widget.almacen!.id : const Uuid().v4(),
        nombre: _nombreController.text.trim(),
        codigo: _codigoController.text.trim(),
        ubicacion: _ubicacionController.text.trim(),
        tipo: _selectedTipo,
        tiendaId: _isEditing 
            ? widget.almacen!.tiendaId 
            : '00000000-0000-0000-0000-000000000001', // Default tienda ID
        capacidadM3: _capacidadController.text.isNotEmpty
            ? double.tryParse(_capacidadController.text)
            : null,
        areaM2: _areaController.text.isNotEmpty
            ? double.tryParse(_areaController.text)
            : null,
        activo: _activo,
        createdAt: _isEditing ? widget.almacen!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: _isEditing ? widget.almacen!.deletedAt : null,
      );

      if (_isEditing) {
        context.read<AlmacenBloc>().add(UpdateAlmacen(almacen: almacen));
      } else {
        context.read<AlmacenBloc>().add(CreateAlmacen(almacen: almacen));
      }
    }
  }
}
