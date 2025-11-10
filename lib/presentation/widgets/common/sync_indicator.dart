import 'package:flutter/material.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/sync/sync_status.dart';

class SyncIndicator extends StatelessWidget {
  final SyncService syncService;

  const SyncIndicator({Key? key, required this.syncService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SyncStatus>(
      stream: syncService.syncStatusStream,
      initialData: syncService.currentStatus,
      builder: (context, snapshot) {
        final status = snapshot.data ?? SyncStatus.idle();

        return _buildIndicator(context, status);
      },
    );
  }

  Widget _buildIndicator(BuildContext context, SyncStatus status) {
    switch (status.state) {
      case SyncState.idle:
        return const SizedBox.shrink();

      case SyncState.syncing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text(
                'Sincronizando ${status.pendingItems} items...',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );

      case SyncState.success:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.green),
              SizedBox(width: 8),
              Text('Sincronizado', style: TextStyle(fontSize: 12)),
            ],
          ),
        );

      case SyncState.error:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                status.message ?? 'Error',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );

      case SyncState.conflict:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, size: 16, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                '${status.conflictItems} conflictos',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
    }
  }
}
