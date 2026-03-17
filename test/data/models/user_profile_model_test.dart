import 'package:flutter_test/flutter_test.dart';

import 'package:btlmobile/data/models/user_profile_model.dart';
import 'package:btlmobile/domain/entities/user_profile.dart';

void main() {
  final now = DateTime(2024, 6, 15, 10, 0);

  group('UserProfileModel', () {
    test('fromFirestore creates correct model', () {
      final data = {
        'email': 'john@test.com',
        'display_name': 'John Doe',
        'photo_url': 'https://example.com/photo.jpg',
        'created_at': '2024-06-15T10:00:00.000',
        'updated_at': '2024-06-15T10:00:00.000',
      };

      final model = UserProfileModel.fromFirestore(data, 'uid123');

      expect(model.uid, 'uid123');
      expect(model.email, 'john@test.com');
      expect(model.displayName, 'John Doe');
      expect(model.photoUrl, 'https://example.com/photo.jpg');
      expect(model.createdAt, now);
      expect(model.updatedAt, now);
    });

    test('fromFirestore handles missing fields', () {
      final data = <String, dynamic>{};

      final model = UserProfileModel.fromFirestore(data, 'uid456');

      expect(model.uid, 'uid456');
      expect(model.email, '');
      expect(model.displayName, '');
      expect(model.photoUrl, '');
    });

    test('toFirestore produces correct map', () {
      final model = UserProfileModel(
        uid: 'uid123',
        email: 'test@test.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: now,
        updatedAt: now,
      );

      final map = model.toFirestore();

      expect(map['email'], 'test@test.com');
      expect(map['display_name'], 'Test User');
      expect(map['photo_url'], 'https://example.com/photo.jpg');
      expect(map['created_at'], now.toIso8601String());
      expect(map['updated_at'], now.toIso8601String());
      expect(map.containsKey('uid'), false);
    });

    test('fromEntity converts correctly', () {
      final entity = UserProfile(
        uid: 'uid789',
        email: 'entity@test.com',
        displayName: 'Entity User',
        photoUrl: '',
        createdAt: now,
        updatedAt: now,
      );

      final model = UserProfileModel.fromEntity(entity);

      expect(model.uid, 'uid789');
      expect(model.email, 'entity@test.com');
      expect(model.displayName, 'Entity User');
    });

    test('UserProfile copyWith works correctly', () {
      final profile = UserProfile(
        uid: 'uid1',
        email: 'test@test.com',
        displayName: 'Old Name',
        photoUrl: '',
        createdAt: now,
        updatedAt: now,
      );

      final updated = profile.copyWith(
        displayName: 'New Name',
        photoUrl: 'new_photo.jpg',
      );

      expect(updated.uid, 'uid1');
      expect(updated.email, 'test@test.com');
      expect(updated.displayName, 'New Name');
      expect(updated.photoUrl, 'new_photo.jpg');
    });

    test('UserProfile props for equality', () {
      final p1 = UserProfile(
        uid: 'uid1',
        email: 'a@b.com',
        createdAt: now,
        updatedAt: now,
      );
      final p2 = UserProfile(
        uid: 'uid1',
        email: 'a@b.com',
        createdAt: now,
        updatedAt: now,
      );

      expect(p1, equals(p2));
    });
  });
}
