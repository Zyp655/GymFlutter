import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app_logger.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    _startListening();
    AppLogger.i('NotificationService initialized');
  }

  void _startListening() {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    _subscription = _firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
          for (final change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added && change.doc.exists) {
              final data = change.doc.data()!;
              final createdByUid = data['createdByUid'] as String?;

              if (createdByUid == currentUid) continue;

              final gymName = data['gymName'] as String? ?? 'New Gym';
              final createdByName =
                  data['createdByName'] as String? ?? 'Someone';

              _showNotification(
                title: '🏋️ Gym mới: $gymName',
                body: '$createdByName vừa thêm gym mới. Vào xem ngay!',
              );
            }
          }
        }, onError: (e) => AppLogger.e('Notification listener error: $e'));
  }

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'new_gym_channel',
      'New Gym Notifications',
      channelDescription: 'Notifications when a new gym is added',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  static Future<void> notifyNewGym({required String gymName}) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('notifications').add({
      'gymName': gymName,
      'createdByUid': user?.uid,
      'createdByName': user?.displayName ?? user?.email ?? 'Unknown',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
