import 'package:flutter_test/flutter_test.dart';

import 'package:btlmobile/data/models/review_model.dart';
import 'package:btlmobile/domain/entities/review.dart';

void main() {
  final now = DateTime(2024, 1, 15, 10, 30);

  group('ReviewModel', () {
    test('fromMap creates correct model', () {
      final map = {
        'id': 1,
        'gym_id': 10,
        'user_id': 'user123',
        'user_name': 'John Doe',
        'rating': 4.5,
        'comment': 'Great place!',
        'created_at': '2024-01-15T10:30:00.000',
      };

      final model = ReviewModel.fromMap(map);

      expect(model.id, 1);
      expect(model.gymId, 10);
      expect(model.userId, 'user123');
      expect(model.userName, 'John Doe');
      expect(model.rating, 4.5);
      expect(model.comment, 'Great place!');
      expect(model.createdAt, DateTime(2024, 1, 15, 10, 30));
    });

    test('toMap produces correct map', () {
      final model = ReviewModel(
        id: 1,
        gymId: 10,
        userId: 'user123',
        userName: 'John Doe',
        rating: 4.5,
        comment: 'Great place!',
        createdAt: now,
      );

      final map = model.toMap();

      expect(map['id'], 1);
      expect(map['gym_id'], 10);
      expect(map['user_id'], 'user123');
      expect(map['user_name'], 'John Doe');
      expect(map['rating'], 4.5);
      expect(map['comment'], 'Great place!');
      expect(map['created_at'], now.toIso8601String());
    });

    test('toMap omits id when null', () {
      final model = ReviewModel(
        gymId: 10,
        userId: 'user123',
        userName: 'John',
        rating: 5.0,
        comment: 'Perfect!',
        createdAt: now,
      );

      final map = model.toMap();
      expect(map.containsKey('id'), false);
    });

    test('fromEntity converts correctly', () {
      final entity = Review(
        id: 5,
        gymId: 3,
        userId: 'user456',
        userName: 'Jane',
        rating: 3.0,
        comment: 'Okay',
        createdAt: now,
      );

      final model = ReviewModel.fromEntity(entity);

      expect(model.id, 5);
      expect(model.gymId, 3);
      expect(model.userId, 'user456');
      expect(model.userName, 'Jane');
      expect(model.rating, 3.0);
      expect(model.comment, 'Okay');
      expect(model.createdAt, now);
    });

    test('fromMap handles integer rating', () {
      final map = {
        'id': 1,
        'gym_id': 10,
        'user_id': 'user123',
        'user_name': 'Test',
        'rating': 4,
        'comment': 'Good',
        'created_at': '2024-01-15T10:30:00.000',
      };

      final model = ReviewModel.fromMap(map);
      expect(model.rating, 4.0);
      expect(model.rating, isA<double>());
    });
  });
}
