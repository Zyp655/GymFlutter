import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/domain/entities/gym.dart';
import 'package:btlmobile/domain/repositories/gym_repository.dart';
import 'package:btlmobile/domain/usecases/gym_commands.dart';
import 'package:btlmobile/domain/usecases/gym_queries.dart';
import 'package:btlmobile/presentation/cubits/gym_list/gym_list_cubit.dart';
import 'package:btlmobile/presentation/cubits/gym_list/gym_list_state.dart';

class MockGymRepository extends Mock implements GymRepository {}

class MockGetAllGyms extends Mock implements GetAllGyms {}

class MockDeleteGym extends Mock implements DeleteGym {}

void main() {
  late MockGetAllGyms mockGetAllGyms;
  late MockDeleteGym mockDeleteGym;
  late GymListCubit cubit;

  final now = DateTime.now();
  final testGyms = [
    Gym(
      id: 1,
      name: 'Fitness First',
      address: '123 Main St',
      phoneNumber: '1234567890',
      email: 'info@fitness.com',
      description: 'A great gym',
      imageUrl: 'https://example.com/gym1.jpg',
      rating: 4.5,
      latitude: 10.0,
      longitude: 20.0,
      openingHours: '6:00 AM - 10:00 PM',
      facilities: ['Pool', 'Sauna'],
      createdAt: now,
      updatedAt: now,
    ),
    Gym(
      id: 2,
      name: 'Gold Gym',
      address: '456 Oak Ave',
      phoneNumber: '0987654321',
      email: 'info@gold.com',
      description: 'Premium gym',
      imageUrl: 'https://example.com/gym2.jpg',
      rating: 5.0,
      latitude: 11.0,
      longitude: 21.0,
      openingHours: '5:00 AM - 11:00 PM',
      facilities: ['Cardio', 'Weights'],
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    mockGetAllGyms = MockGetAllGyms();
    mockDeleteGym = MockDeleteGym();
    cubit = GymListCubit(getAllGyms: mockGetAllGyms, deleteGym: mockDeleteGym);
  });

  tearDown(() {
    cubit.close();
  });

  group('GymListCubit', () {
    test('initial state is GymListInitial', () {
      expect(cubit.state, isA<GymListInitial>());
    });

    blocTest<GymListCubit, GymListState>(
      'emits [GymListLoading, GymListLoaded] when loadGyms succeeds',
      build: () {
        when(() => mockGetAllGyms()).thenAnswer((_) async => testGyms);
        return cubit;
      },
      act: (cubit) => cubit.loadGyms(),
      expect: () => [
        isA<GymListLoading>(),
        isA<GymListLoaded>().having(
          (state) => state.gyms.length,
          'gyms count',
          2,
        ),
      ],
    );

    blocTest<GymListCubit, GymListState>(
      'emits [GymListLoading, GymListError] when loadGyms fails',
      build: () {
        when(() => mockGetAllGyms()).thenThrow(Exception('Database error'));
        return cubit;
      },
      act: (cubit) => cubit.loadGyms(),
      expect: () => [isA<GymListLoading>(), isA<GymListError>()],
    );

    blocTest<GymListCubit, GymListState>(
      'searchGyms filters gyms by name',
      build: () {
        when(() => mockGetAllGyms()).thenAnswer((_) async => testGyms);
        return cubit;
      },
      seed: () => GymListLoaded(gyms: testGyms, filteredGyms: testGyms),
      act: (cubit) => cubit.searchGyms('Gold'),
      expect: () => [
        isA<GymListLoaded>().having(
          (state) => state.filteredGyms.length,
          'filtered gyms count',
          1,
        ),
      ],
    );

    blocTest<GymListCubit, GymListState>(
      'filterByRating filters gyms with rating >= minRating',
      build: () {
        when(() => mockGetAllGyms()).thenAnswer((_) async => testGyms);
        return cubit;
      },
      seed: () => GymListLoaded(gyms: testGyms, filteredGyms: testGyms),
      act: (cubit) => cubit.filterByRating(5.0),
      expect: () => [
        isA<GymListLoaded>()
            .having((state) => state.filteredGyms.length, 'filtered count', 1)
            .having((state) => state.minRatingFilter, 'minRating', 5.0),
      ],
    );

    blocTest<GymListCubit, GymListState>(
      'deleteGym removes gym from list',
      build: () {
        when(() => mockDeleteGym(1)).thenAnswer((_) async => 1);
        when(() => mockGetAllGyms()).thenAnswer((_) async => [testGyms[1]]);
        return cubit;
      },
      seed: () => GymListLoaded(gyms: testGyms, filteredGyms: testGyms),
      act: (cubit) => cubit.deleteGym(1),
      expect: () => [
        isA<GymListLoaded>().having(
          (state) => state.gyms.length,
          'remaining gyms',
          1,
        ),
      ],
    );
  });
}
