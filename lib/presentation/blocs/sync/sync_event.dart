import 'package:equatable/equatable.dart';
import '../../../core/sync/sync_status.dart' as core;

abstract class SyncEvent extends Equatable {
  const SyncEvent();
}

/// Evento para iniciar sincronización manual
class SyncStarted extends SyncEvent {
  const SyncStarted();

  @override
  List<Object?> get props => [];
}

/// Evento cuando el estado de sincronización cambia (interno)
class SyncStatusChanged extends SyncEvent {
  final core.SyncStatus status;

  const SyncStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}
