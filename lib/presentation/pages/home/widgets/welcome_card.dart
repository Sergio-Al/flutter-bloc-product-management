import 'package:flutter/material.dart';
import '../../../../domain/entities/usuario.dart';
import '../utils/role_utils.dart';

class WelcomeCard extends StatelessWidget {
  final Usuario user;
  final String roleName;

  const WelcomeCard({
    Key? key,
    required this.user,
    required this.roleName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roleIcon = RoleUtils.getRoleIcon(roleName);
    final roleColor = RoleUtils.getRoleColor(roleName);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildAvatar(context),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Bienvenido!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.nombreCompleto,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  _buildRoleBadge(context, roleIcon, roleColor),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        user.nombreCompleto.isNotEmpty
            ? user.nombreCompleto[0].toUpperCase()
            : '?',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          roleName,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
