import 'dart:convert';

import '../database/database_helper.dart';

enum SyncAction { create, update, delete }

class SyncQueueItem {
  final int? id;
  final String entityType;
  final int entityId;
  final SyncAction action;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final int retryCount;

  SyncQueueItem({
    this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.data,
    required this.createdAt,
    this.retryCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'action': action.name,
      'data': data != null ? jsonEncode(data) : null,
      'created_at': createdAt.toIso8601String(),
      'retry_count': retryCount,
    };
  }

  factory SyncQueueItem.fromMap(Map<String, dynamic> map) {
    return SyncQueueItem(
      id: map['id'] as int?,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as int,
      action: SyncAction.values.firstWhere((e) => e.name == map['action']),
      data: map['data'] != null ? jsonDecode(map['data'] as String) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      retryCount: map['retry_count'] as int? ?? 0,
    );
  }

  SyncQueueItem copyWith({int? retryCount}) {
    return SyncQueueItem(
      id: id,
      entityType: entityType,
      entityId: entityId,
      action: action,
      data: data,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

class SyncQueueDataSource {
  final DatabaseHelper _databaseHelper;
  static const String _tableName = 'sync_queue';

  SyncQueueDataSource({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  Future<int> addToQueue(SyncQueueItem item) async {
    final db = await _databaseHelper.database;
    return await db.insert(_tableName, item.toMap());
  }

  Future<List<SyncQueueItem>> getPendingItems({int limit = 50}) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      _tableName,
      orderBy: 'created_at ASC',
      limit: limit,
    );
    return results.map((map) => SyncQueueItem.fromMap(map)).toList();
  }

  Future<int> getPendingCount() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName',
    );
    return result.first['count'] as int? ?? 0;
  }

  Future<void> removeFromQueue(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> incrementRetryCount(int id) async {
    final db = await _databaseHelper.database;
    await db.rawUpdate(
      'UPDATE $_tableName SET retry_count = retry_count + 1 WHERE id = ?',
      [id],
    );
  }

  Future<void> clearQueue() async {
    final db = await _databaseHelper.database;
    await db.delete(_tableName);
  }
}
