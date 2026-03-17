import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/data/datasources/gym_local_datasource.dart';
import 'package:btlmobile/data/models/gym_model.dart';
import 'package:btlmobile/data/repositories/gym_repository_impl.dart';
import 'package:btlmobile/domain/entities/gym.dart';

class MockGymLocalDataSource extends Mock implements GymLocalDataSource {}

class FakeGymModel extends Fake implements GymModel {}

void main() {
  late MockGymLocalDataSource mockDataSource;
  late GymRepositoryImpl repository;

  final now = DateTime.now();
  final testModels = [
    GymModel(
      id: 1,
      name: 'Gym A',
      address: 'Addr A',
      phoneNumber: '111',
      email: 'a@g.com',
      description: 'Desc A',
      imageUrl: 'url_a',
      rating: 4.0,
      latitude: 10.0,
      longitude: 20.0,
      openingHours: '6-10',
      facilities: ['Pool'],
      createdAt: now,
      updatedAt: now,
    ),
    GymModel(
      id: 2,
      name: 'Gym B',
      address: 'Addr B',
      phoneNumber: '222',
      email: 'b@g.com',
      description: 'Desc B',
      imageUrl: 'url_b',
      rating: 5.0,
      latitude: 11.0,
      longitude: 21.0,
      openingHours: '24h',
      facilities: ['Sauna'],
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeGymModel());
  });

  setUp(() {
    mockDataSource = MockGymLocalDataSource();
    repository = GymRepositoryImpl(localDataSource: mockDataSource);
  });

  group('GymRepositoryImpl', () {
    test('getAllGyms returns list of Gym entities', () async {
      when(
        () => mockDataSource.getAllGyms(),
      ).thenAnswer((_) async => testModels);

      final result = await repository.getAllGyms();

      expect(result, isA<List<Gym>>());
      expect(result.length, 2);
      expect(result[0].name, 'Gym A');
    });

    test('getGymById returns gym when found', () async {
      when(
        () => mockDataSource.getGymById(1),
      ).thenAnswer((_) async => testModels[0]);

      final result = await repository.getGymById(1);

      expect(result, isNotNull);
      expect(result!.name, 'Gym A');
    });

    test('getGymById returns null when not found', () async {
      when(() => mockDataSource.getGymById(99)).thenAnswer((_) async => null);

      final result = await repository.getGymById(99);

      expect(result, isNull);
    });

    test('searchGyms delegates to datasource', () async {
      when(
        () => mockDataSource.searchGyms('Pool'),
      ).thenAnswer((_) async => [testModels[0]]);

      final result = await repository.searchGyms('Pool');

      expect(result.length, 1);
      verify(() => mockDataSource.searchGyms('Pool')).called(1);
    });

    test('insertGym converts entity to model and inserts', () async {
      when(() => mockDataSource.insertGym(any())).thenAnswer((_) async => 3);

      final gym = Gym(
        name: 'New Gym',
        address: 'New Addr',
        phoneNumber: '333',
        email: 'n@g.com',
        description: 'New',
        imageUrl: 'url_n',
        rating: 3.5,
        latitude: 0,
        longitude: 0,
        openingHours: '9-5',
        facilities: [],
        createdAt: now,
        updatedAt: now,
      );

      final result = await repository.insertGym(gym);

      expect(result, 3);
      verify(() => mockDataSource.insertGym(any())).called(1);
    });

    test('deleteGym delegates to datasource', () async {
      when(() => mockDataSource.deleteGym(1)).thenAnswer((_) async => 1);

      final result = await repository.deleteGym(1);

      expect(result, 1);
      verify(() => mockDataSource.deleteGym(1)).called(1);
    });
  });
}
