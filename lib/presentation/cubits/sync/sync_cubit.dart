import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/app_logger.dart';
import '../../../data/services/sync_service.dart';
import 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final SyncService _syncService;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  SyncCubit({SyncService? syncService, Connectivity? connectivity})
    : _syncService = syncService ?? SyncService(),
      _connectivity = connectivity ?? Connectivity(),
      super(const SyncIdle());

  void startAutoSync() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      if (isConnected) {
        syncNow();
      }
    });

    _updatePendingCount();
  }

  Future<void> _updatePendingCount() async {
    final count = await _syncService.getPendingCount();
    if (state is SyncIdle) {
      emit(SyncIdle(pendingCount: count));
    }
  }

  Future<void> syncNow() async {
    if (state is SyncInProgress) return;

    emit(const SyncInProgress());

    try {
      final pushResult = await _syncService.syncPendingChanges();

      final pullResult = await _syncService.pullFromCloud();

      final totalSynced = pushResult.syncedCount + pullResult.syncedCount;
      final totalFailed = pushResult.failedCount + pullResult.failedCount;

      emit(SyncComplete(syncedCount: totalSynced, failedCount: totalFailed));

      await Future.delayed(const Duration(seconds: 2));
      await _updatePendingCount();
    } catch (e, stackTrace) {
      AppLogger.e('Sync failed', e, stackTrace);
      emit(SyncError(e.toString()));

      await Future.delayed(const Duration(seconds: 3));
      await _updatePendingCount();
    }
  }

  Future<void> refreshPendingCount() async {
    await _updatePendingCount();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
