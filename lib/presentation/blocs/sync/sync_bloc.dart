// presentation/blocs/sync/sync_bloc.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/sync/sync_manager.dart';
import '../../../core/sync/sync_status.dart' as core;
import 'sync_event.dart';
import 'sync_state.dart';

/// BLoC para gestionar el estado de sincronización
class SyncBloc extends Bloc<SyncEvent, SyncBlocState> {
  final SyncManager syncManager;
  StreamSubscription<core.SyncStatus>? _syncSubscription;

  SyncBloc({required this.syncManager}) : super(const SyncIdle()) {
    on<SyncStarted>(_onSyncStarted);
    on<SyncStatusChanged>(_onSyncStatusChanged);
    
    // Listen to sync status stream from SyncManager
    _syncSubscription = syncManager.syncStatusStream.listen(
      (status) => add(SyncStatusChanged(status)),
    );
  }

  Future<void> _onSyncStarted(
    SyncStarted event,
    Emitter<SyncBlocState> emit,
  ) async {
    try {
      final result = await syncManager.syncAll();
      result.fold(
        (failure) => emit(SyncFailed(message: failure.message)),
        (_) {}, // Success is handled by the stream listener
      );
    } catch (e) {
      emit(SyncFailed(message: e.toString()));
    }
  }

  void _onSyncStatusChanged(
    SyncStatusChanged event,
    Emitter<SyncBlocState> emit,
  ) {
    emit(event.status.toBlocState());
  }

  @override
  Future<void> close() {
    _syncSubscription?.cancel();
    return super.close();
  }
}
