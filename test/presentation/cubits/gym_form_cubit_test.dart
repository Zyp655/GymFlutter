import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/domain/entities/gym.dart';
import 'package:btlmobile/domain/usecases/gym_commands.dart';
import 'package:btlmobile/domain/usecases/gym_queries.dart';
import 'package:btlmobile/presentation/cubits/gym_form/gym_form_cubit.dart';
import 'package:btlmobile/presentation/cubits/gym_form/gym_form_state.dart';

class MockGetGymById extends Mock implements GetGymById {}

class MockInsertGym extends Mock implements InsertGym {}

class MockUpdateGym extends Mock implements UpdateGym {}

class FakeGym extends Fake implements Gym {}

void main() {
  late MockGetGymById mockGetGymById;
  late MockInsertGym mockInsertGym;
  late MockUpdateGym mockUpdateGym;
  late GymFormCubit cubit;

  final now = DateTime.now();
  final testGym = Gym(
    id: 1,
    name: 'Test Gym',
    address: '123 Test St',
    phoneNumber: '1234567890',
    email: 'test@gym.com',
    description: 'A test gym',
    imageUrl: 'https://example.com/test.jpg',
    rating: 4.0,
    latitude: 10.0,
    longitude: 20.0,
    openingHours: '6:00 AM - 10:00 PM',
    facilities: ['Pool', 'Gym'],
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeGym());
  });

  setUp(() {
    mockGetGymById = MockGetGymById();
    mockInsertGym = MockInsertGym();
    mockUpdateGym = MockUpdateGym();
    cubit = GymFormCubit(
      getGymById: mockGetGymById,
      insertGym: mockInsertGym,
      updateGym: mockUpdateGym,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('GymFormCubit', () {
    test('initial state is GymFormInitial', () {
      expect(cubit.state, isA<GymFormInitial>());
    });

    blocTest<GymFormCubit, GymFormState>(
      'initializeForEdit emits GymFormEditing with gym data',
      build: () {
        when(() => mockGetGymById(1)).thenAnswer((_) async => testGym);
        return cubit;
      },
      act: (cubit) => cubit.initializeForEdit(1),
      expect: () => [
        isA<GymFormEditing>().having(
          (state) => state.gym?.name,
          'gym name',
          'Test Gym',
        ),
      ],
    );

    blocTest<GymFormCubit, GymFormState>(
      'initializeForCreate emits GymFormEditing without gym',
      build: () => cubit,
      act: (cubit) => cubit.initializeForCreate(),
      expect: () => [
        isA<GymFormEditing>().having((state) => state.gym, 'gym', isNull),
      ],
    );

    blocTest<GymFormCubit, GymFormState>(
      'submitGym creates new gym when not editing',
      build: () {
        when(() => mockInsertGym(any())).thenAnswer((_) async => 1);
        return cubit;
      },
      seed: () => const GymFormEditing(isEditMode: false),
      act: (cubit) => cubit.submitGym(
        name: 'New Gym',
        address: '456 New St',
        phoneNumber: '0987654321',
        email: 'new@gym.com',
        description: 'A new gym',
        imageUrl: 'https://example.com/new.jpg',
        latitude: 15.0,
        longitude: 25.0,
        openingHours: '7:00 AM - 9:00 PM',
        facilities: ['Cardio'],
      ),
      expect: () => [isA<GymFormSubmitting>(), isA<GymFormSuccess>()],
      verify: (_) {
        verify(() => mockInsertGym(any())).called(1);
      },
    );

    blocTest<GymFormCubit, GymFormState>(
      'submitGym updates existing gym when editing',
      build: () {
        when(() => mockUpdateGym(any())).thenAnswer((_) async => 1);
        return cubit;
      },
      seed: () => GymFormEditing(gym: testGym, isEditMode: true),
      act: (cubit) => cubit.submitGym(
        name: 'Updated Gym',
        address: '456 New St',
        phoneNumber: '0987654321',
        email: 'updated@gym.com',
        description: 'Updated description',
        imageUrl: 'https://example.com/updated.jpg',
        latitude: 15.0,
        longitude: 25.0,
        openingHours: '7:00 AM - 9:00 PM',
        facilities: ['Cardio', 'Weights'],
      ),
      expect: () => [isA<GymFormSubmitting>(), isA<GymFormSuccess>()],
      verify: (_) {
        verify(() => mockUpdateGym(any())).called(1);
      },
    );

    blocTest<GymFormCubit, GymFormState>(
      'submitGym emits GymFormError on failure',
      build: () {
        when(() => mockInsertGym(any())).thenThrow(Exception('Database error'));
        return cubit;
      },
      seed: () => const GymFormEditing(isEditMode: false),
      act: (cubit) => cubit.submitGym(
        name: 'New Gym',
        address: '456 New St',
        phoneNumber: '0987654321',
        email: 'new@gym.com',
        description: 'A new gym',
        imageUrl: 'https://example.com/new.jpg',
        latitude: 15.0,
        longitude: 25.0,
        openingHours: '7:00 AM - 9:00 PM',
        facilities: ['Cardio'],
      ),
      expect: () => [isA<GymFormSubmitting>(), isA<GymFormError>()],
    );
  });
}
