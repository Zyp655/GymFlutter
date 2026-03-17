import 'package:equatable/equatable.dart';

enum SyncStatus { idle, syncing, success, error }

abstract class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

class SyncIdle extends SyncState {
  final int pendingCount;

  const SyncIdle({this.pendingCount = 0});

  @override
  List<Object?> get props => [pendingCount];
}

class SyncInProgress extends SyncState {
  final int totalItems;
  final int currentItem;

  const SyncInProgress({this.totalItems = 0, this.currentItem = 0});

  @override
  List<Object?> get props => [totalItems, currentItem];
}

class SyncComplete extends SyncState {
  final int syncedCount;
  final int failedCount;

  const SyncComplete({this.syncedCount = 0, this.failedCount = 0});

  @override
  List<Object?> get props => [syncedCount, failedCount];
}

class SyncError extends SyncState {
  final String message;

  const SyncError(this.message);

  @override
  List<Object?> get props => [message];
}
