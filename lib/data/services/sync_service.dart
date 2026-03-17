import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/app_logger.dart';
import '../../domain/entities/gym.dart';
import '../datasources/sync_queue_datasource.dart';
import '../database/database_helper.dart';
import '../models/gym_model.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncResult {
  final bool success;
  final int syncedCount;
  final int failedCount;
  final String? errorMessage;

  SyncResult({
    required this.success,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.errorMessage,
  });
}

class SyncService {
  final FirebaseFirestore _firestore;
  final DatabaseHelper _databaseHelper;
  final SyncQueueDataSource _syncQueue;

  static const String _gymsCollection = 'gyms';
  static const int _maxRetries = 3;

  SyncService({
    FirebaseFirestore? firestore,
    DatabaseHelper? databaseHelper,
    SyncQueueDataSource? syncQueue,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
       _syncQueue = syncQueue ?? SyncQueueDataSource();

  Future<SyncResult> syncPendingChanges() async {
    int syncedCount = 0;
    int failedCount = 0;

    try {
      final pendingItems = await _syncQueue.getPendingItems();
      AppLogger.i('Syncing ${pendingItems.length} pending items...');

      for (final item in pendingItems) {
        if (item.retryCount >= _maxRetries) {
          await _syncQueue.removeFromQueue(item.id!);
          failedCount++;
          continue;
        }

        try {
          await _processSyncItem(item);
          await _syncQueue.removeFromQueue(item.id!);
          syncedCount++;
        } catch (e) {
          AppLogger.w(
            'Sync item ${item.id} failed, retry ${item.retryCount + 1}',
            e,
          );
          await _syncQueue.incrementRetryCount(item.id!);
          failedCount++;
        }
      }

      return SyncResult(
        success: failedCount == 0,
        syncedCount: syncedCount,
        failedCount: failedCount,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Sync failed', e, stackTrace);
      return SyncResult(
        success: false,
        syncedCount: syncedCount,
        failedCount: failedCount,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _processSyncItem(SyncQueueItem item) async {
    switch (item.entityType) {
      case 'gym':
        await _syncGymItem(item);
        break;
      default:
        throw Exception('Unknown entity type: ${item.entityType}');
    }
  }

  Future<void> _syncGymItem(SyncQueueItem item) async {
    final docRef = _firestore
        .collection(_gymsCollection)
        .doc(item.entityId.toString());

    switch (item.action) {
      case SyncAction.create:
      case SyncAction.update:
        if (item.data != null) {
          await docRef.set(item.data!, SetOptions(merge: true));
        }
        break;
      case SyncAction.delete:
        await docRef.delete();
        break;
    }
  }

  Future<SyncResult> pullFromCloud({String? userId}) async {
    try {
      final snapshot = await _firestore.collection(_gymsCollection).get();
      int syncedCount = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final localId = int.tryParse(doc.id);

        if (localId != null) {
          final existing = await _databaseHelper.queryById(
            AppConstants.gymTable,
            localId,
          );

          if (existing == null) {
            final gymData = _convertFirestoreToLocal(data, localId);
            await _databaseHelper.insert(AppConstants.gymTable, gymData);
            syncedCount++;
          } else {
            final cloudUpdatedAt = DateTime.tryParse(data['updated_at'] ?? '');
            final localUpdatedAt = DateTime.tryParse(
              existing['updated_at'] ?? '',
            );

            if (cloudUpdatedAt != null &&
                localUpdatedAt != null &&
                cloudUpdatedAt.isAfter(localUpdatedAt)) {
              final gymData = _convertFirestoreToLocal(data, localId);
              await _databaseHelper.update(
                AppConstants.gymTable,
                gymData,
                localId,
              );
              syncedCount++;
            }
          }
        }
      }

      return SyncResult(success: true, syncedCount: syncedCount);
    } catch (e) {
      return SyncResult(success: false, errorMessage: e.toString());
    }
  }

  Map<String, dynamic> _convertFirestoreToLocal(
    Map<String, dynamic> data,
    int id,
  ) {
    return {
      'id': id,
      'name': data['name'] ?? '',
      'address': data['address'] ?? '',
      'phone_number': data['phone_number'] ?? '',
      'email': data['email'] ?? '',
      'description': data['description'] ?? '',
      'image_url': data['image_url'] ?? '',
      'rating': (data['rating'] as num?)?.toDouble() ?? 0.0,
      'latitude': (data['latitude'] as num?)?.toDouble() ?? 0.0,
      'longitude': (data['longitude'] as num?)?.toDouble() ?? 0.0,
      'opening_hours': data['opening_hours'] ?? '',
      'facilities': data['facilities'] ?? '',
      'created_at': data['created_at'] ?? DateTime.now().toIso8601String(),
      'updated_at': data['updated_at'] ?? DateTime.now().toIso8601String(),
    };
  }

  Future<void> queueGymSync(Gym gym, SyncAction action) async {
    await _syncQueue.addToQueue(
      SyncQueueItem(
        entityType: 'gym',
        entityId: gym.id ?? 0,
        action: action,
        data: action != SyncAction.delete
            ? GymModel.fromEntity(gym).toMap()
            : null,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<int> getPendingCount() async {
    return await _syncQueue.getPendingCount();
  }
}
