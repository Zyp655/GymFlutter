import 'package:flutter_test/flutter_test.dart';

import 'package:btlmobile/data/models/gym_model.dart';
import 'package:btlmobile/domain/entities/gym.dart';

void main() {
  final now = DateTime(2024, 1, 15, 10, 30);

  final testMap = {
    'id': 1,
    'name': 'Test Gym',
    'address': '123 Test St',
    'phone_number': '+1234567890',
    'email': 'test@gym.com',
    'description': 'A test gym',
    'image_url': 'https://example.com/test.jpg',
    'rating': 4.5,
    'latitude': 10.0,
    'longitude': 20.0,
    'opening_hours': '6:00 AM - 10:00 PM',
    'facilities': 'Pool,Sauna,WiFi',
    'created_at': '2024-01-15T10:30:00.000',
    'updated_at': '2024-01-15T10:30:00.000',
  };

  final testGym = Gym(
    id: 1,
    name: 'Test Gym',
    address: '123 Test St',
    phoneNumber: '+1234567890',
    email: 'test@gym.com',
    description: 'A test gym',
    imageUrl: 'https://example.com/test.jpg',
    rating: 4.5,
    latitude: 10.0,
    longitude: 20.0,
    openingHours: '6:00 AM - 10:00 PM',
    facilities: ['Pool', 'Sauna', 'WiFi'],
    createdAt: now,
    updatedAt: now,
  );

  group('GymModel', () {
    test('fromMap creates correct model', () {
      final model = GymModel.fromMap(testMap);

      expect(model.id, 1);
      expect(model.name, 'Test Gym');
      expect(model.address, '123 Test St');
      expect(model.phoneNumber, '+1234567890');
      expect(model.email, 'test@gym.com');
      expect(model.rating, 4.5);
      expect(model.facilities, ['Pool', 'Sauna', 'WiFi']);
      expect(model.latitude, 10.0);
      expect(model.longitude, 20.0);
    });

    test('toMap creates correct map', () {
      final model = GymModel.fromMap(testMap);
      final map = model.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'Test Gym');
      expect(map['phone_number'], '+1234567890');
      expect(map['rating'], 4.5);
      expect(map['facilities'], 'Pool,Sauna,WiFi');
    });

    test('fromEntity creates model from entity', () {
      final model = GymModel.fromEntity(testGym);

      expect(model.id, testGym.id);
      expect(model.name, testGym.name);
      expect(model.rating, testGym.rating);
      expect(model.facilities, testGym.facilities);
    });

    test('round-trip fromMap -> toMap preserves data', () {
      final model = GymModel.fromMap(testMap);
      final map = model.toMap();

      expect(map['name'], testMap['name']);
      expect(map['email'], testMap['email']);
      expect(map['rating'], testMap['rating']);
      expect(map['facilities'], testMap['facilities']);
    });

    test('fromMap handles empty facilities string', () {
      final mapWithEmptyFacilities = Map<String, dynamic>.from(testMap);
      mapWithEmptyFacilities['facilities'] = '';

      final model = GymModel.fromMap(mapWithEmptyFacilities);
      expect(model.facilities, isEmpty);
    });

    test('toMap excludes id when null', () {
      final model = GymModel(
        name: 'New Gym',
        address: 'Address',
        phoneNumber: '123',
        email: 'e@e.com',
        description: 'desc',
        imageUrl: 'url',
        rating: 3.0,
        latitude: 0,
        longitude: 0,
        openingHours: '24h',
        facilities: [],
        createdAt: now,
        updatedAt: now,
      );

      final map = model.toMap();
      expect(map.containsKey('id'), isFalse);
    });
  });
}
