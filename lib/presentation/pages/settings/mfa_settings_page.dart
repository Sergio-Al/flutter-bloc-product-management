import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../data/datasources/remote/auth_remote_datasource.dart';
import '../../../core/utils/logger.dart';

/// Página de configuración de seguridad (MFA y sesiones)
class MfaSettingsPage extends StatefulWidget {
  const MfaSettingsPage({super.key});

  @override
  State<MfaSettingsPage> createState() => _MfaSettingsPageState();
}

class _MfaSettingsPageState extends State<MfaSettingsPage> {
  final AuthRemoteDataSource _authDataSource = AuthRemoteDataSource();
  
  bool _isLoading = false;
  bool _mfaEnabled = false;
  String? _qrCodeBase64;
  String? _secret;
  final _tokenController = TextEditingController();
  
  // Información del perfil
  String? _email;
  int _failedAttempts = 0;
  
  @override
  void initState() {
    super.initState();
    _loadMfaStatus();
  }
  
  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }
  
  Future<void> _loadMfaStatus() async {
    try {
      final profile = await _authDataSource.getUserProfile();
      setState(() {
        // Backend returns snake_case: mfa_enabled
        _mfaEnabled = profile['mfa_enabled'] as bool? ?? false;
        _email = profile['email'] as String?;
        _failedAttempts = profile['failed_login_attempts'] as int? ?? 0;
      });
    } catch (e) {
      AppLogger.error('Error al cargar estado MFA', e);
    }
  }
  
  Future<void> _enableMfa() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await _authDataSource.enableMfa();
      
      setState(() {
        _qrCodeBase64 = response['qrCode'] as String?;
        _secret = response['secret'] as String?;
        _isLoading = false;
      });
      
      if (mounted) {
        _showVerificationDialog();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al habilitar MFA: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      AppLogger.error('Error al habilitar MFA', e);
    }
  }
  
  Future<void> _verifyAndEnableMfa() async {
    if (_tokenController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El código debe tener 6 dígitos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await _authDataSource.verifyMfaSetup(token: _tokenController.text);
      
      setState(() {
        _mfaEnabled = true;
        _qrCodeBase64 = null;
        _secret = null;
        _isLoading = false;
      });
      
      _tokenController.clear();
      
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ MFA habilitado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código inválido: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      AppLogger.error('Error al verificar MFA', e);
    }
  }
  
  Future<void> _disableMfa() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deshabilitar MFA'),
        content: const Text(
          '¿Estás seguro de que deseas deshabilitar la autenticación multifactor? '
          'Esto hará que tu cuenta sea menos segura.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Deshabilitar'),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    setState(() => _isLoading = true);
    
    try {
      await _authDataSource.disableMfa();
      
      setState(() {
        _mfaEnabled = false;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('MFA deshabilitado'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al deshabilitar MFA: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      AppLogger.error('Error al deshabilitar MFA', e);
    }
  }
  
  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Configurar Autenticador'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1. Escanea el código QR con tu app de autenticación:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // QR Code Display
              if (_qrCodeBase64 != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Image.memory(
                      base64Decode(_qrCodeBase64!.split(',').last),
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Secret Key (manual entry)
              if (_secret != null) ...[
                const Text(
                  '2. O ingresa este código manualmente:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          _secret!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _secret!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Código copiado'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        tooltip: 'Copiar código',
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              const Text(
                '3. Ingresa el código de 6 dígitos:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              // Token Input
              TextField(
                controller: _tokenController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  hintText: '000000',
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () {
              _tokenController.clear();
              setState(() {
                _qrCodeBase64 = null;
                _secret = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _verifyAndEnableMfa,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Verificar'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación Multifactor (MFA)'),
      ),
      body: _isLoading && _qrCodeBase64 == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: Colors.blue.shade700,
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¿Qué es MFA?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Autenticación Multifactor agrega una capa extra de seguridad '
                                  'requiriendo un código de 6 dígitos además de tu contraseña.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Status Card
                  Card(
                    child: ListTile(
                      leading: Icon(
                        _mfaEnabled ? Icons.check_circle : Icons.cancel,
                        color: _mfaEnabled ? Colors.green : Colors.grey,
                        size: 40,
                      ),
                      title: Text(
                        _mfaEnabled ? 'MFA Habilitado' : 'MFA Deshabilitado',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _mfaEnabled
                            ? 'Tu cuenta está protegida con autenticación multifactor'
                            : 'Habilita MFA para mayor seguridad',
                      ),
                      trailing: Switch(
                        value: _mfaEnabled,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                if (value) {
                                  _enableMfa();
                                } else {
                                  _disableMfa();
                                }
                              },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Instructions Card
                  if (!_mfaEnabled) ...[
                    const Text(
                      'Cómo habilitar MFA:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionStep(
                      '1',
                      'Descarga una app de autenticación',
                      'Google Authenticator, Microsoft Authenticator, Authy, etc.',
                      Icons.smartphone,
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep(
                      '2',
                      'Activa el switch de MFA',
                      'Se generará un código QR único para tu cuenta',
                      Icons.qr_code,
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep(
                      '3',
                      'Escanea el código QR',
                      'Usa tu app de autenticación para escanear el código',
                      Icons.camera_alt,
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep(
                      '4',
                      'Ingresa el código de verificación',
                      'Tu app generará un código de 6 dígitos para confirmar',
                      Icons.password,
                    ),
                  ] else ...[
                    const Text(
                      'MFA está activo:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Configuración completada',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ahora necesitarás ingresar un código de 6 dígitos cada vez que inicies sesión.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  // ============================================
                  // Security Section - Session Management
                  // ============================================
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Gestión de Sesiones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Security Status Card
                  if (_failedAttempts > 0)
                    Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange.shade700,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Intentos de login fallidos: $_failedAttempts',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Si no reconoces estos intentos, considera cambiar tu contraseña y revocar sesiones.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  if (_failedAttempts > 0) const SizedBox(height: 16),
                  
                  // Account Email Display
                  if (_email != null)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.account_circle, size: 40),
                        title: Text(_email!),
                        subtitle: const Text('Cuenta actual'),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Revoke All Sessions Button
                  Card(
                    color: Colors.red.shade50,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red.shade700,
                        size: 40,
                      ),
                      title: Text(
                        'Cerrar todas las sesiones',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      subtitle: Text(
                        'Cierra sesión en todos los dispositivos',
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _isLoading ? null : _revokeAllSessions,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  
  /// Revoca todas las sesiones activas
  Future<void> _revokeAllSessions() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar todas las sesiones'),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión en todos los dispositivos?\n\n'
          'Tendrás que iniciar sesión nuevamente en este dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cerrar sesiones'),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    setState(() => _isLoading = true);
    
    try {
      await _authDataSource.revokeAllSessions();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Todas las sesiones han sido cerradas'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Redirigir al login
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      AppLogger.error('Error al revocar sesiones', e);
    }
  }
  
  Widget _buildInstructionStep(
    String number,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Icon(icon, color: Colors.grey.shade600, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
