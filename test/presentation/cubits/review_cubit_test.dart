import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/domain/entities/review.dart';
import 'package:btlmobile/domain/repositories/gym_repository.dart';
import 'package:btlmobile/domain/repositories/review_repository.dart';
import 'package:btlmobile/presentation/cubits/review/review_cubit.dart';
import 'package:btlmobile/presentation/cubits/review/review_state.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

class MockGymRepository extends Mock implements GymRepository {}

void main() {
  late MockReviewRepository mockRepository;
  late MockGymRepository mockGymRepository;
  late ReviewCubit cubit;

  final testReviews = [
    Review(
      id: 1,
      gymId: 1,
      userId: 'user1',
      userName: 'John',
      rating: 4.5,
      comment: 'Great gym!',
      createdAt: DateTime.now(),
    ),
    Review(
      id: 2,
      gymId: 1,
      userId: 'user2',
      userName: 'Jane',
      rating: 5.0,
      comment: 'Best gym ever!',
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    mockRepository = MockReviewRepository();
    mockGymRepository = MockGymRepository();
    when(
      () => mockGymRepository.updateGymRating(any(), any()),
    ).thenAnswer((_) async {});
    cubit = ReviewCubit(
      reviewRepository: mockRepository,
      gymRepository: mockGymRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  setUpAll(() {
    registerFallbackValue(
      Review(
        gymId: 1,
        userId: 'u',
        userName: 'n',
        rating: 5,
        comment: 'c',
        createdAt: DateTime.now(),
      ),
    );
  });

  group('ReviewCubit', () {
    test('initial state is ReviewInitial', () {
      expect(cubit.state, isA<ReviewInitial>());
    });

    blocTest<ReviewCubit, ReviewState>(
      'loadReviews emits [ReviewLoading, ReviewLoaded] on success',
      build: () {
        when(
          () => mockRepository.getReviewsForGym(1),
        ).thenAnswer((_) async => testReviews);
        when(
          () => mockRepository.getAverageRating(1),
        ).thenAnswer((_) async => 4.75);
        when(() => mockRepository.getReviewCount(1)).thenAnswer((_) async => 2);
        return cubit;
      },
      act: (cubit) => cubit.loadReviews(1),
      expect: () => [
        isA<ReviewLoading>(),
        isA<ReviewLoaded>()
            .having((s) => s.reviews.length, 'count', 2)
            .having((s) => s.averageRating, 'avg', 4.75)
            .having((s) => s.reviewCount, 'total', 2),
      ],
    );

    blocTest<ReviewCubit, ReviewState>(
      'loadReviews emits [ReviewLoading, ReviewError] on failure',
      build: () {
        when(
          () => mockRepository.getReviewsForGym(1),
        ).thenThrow(Exception('DB error'));
        return cubit;
      },
      act: (cubit) => cubit.loadReviews(1),
      expect: () => [isA<ReviewLoading>(), isA<ReviewError>()],
    );

    blocTest<ReviewCubit, ReviewState>(
      'addReview calls repository and reloads',
      build: () {
        when(() => mockRepository.addReview(any())).thenAnswer((_) async {});
        when(
          () => mockRepository.getReviewsForGym(1),
        ).thenAnswer((_) async => testReviews);
        when(
          () => mockRepository.getAverageRating(1),
        ).thenAnswer((_) async => 4.75);
        when(() => mockRepository.getReviewCount(1)).thenAnswer((_) async => 2);
        return cubit;
      },
      act: (cubit) => cubit.addReview(
        gymId: 1,
        userId: 'user3',
        userName: 'Bob',
        rating: 4.0,
        comment: 'Nice place',
      ),
      expect: () => [isA<ReviewLoading>(), isA<ReviewLoaded>()],
      verify: (_) {
        verify(() => mockRepository.addReview(any())).called(1);
      },
    );

    blocTest<ReviewCubit, ReviewState>(
      'deleteReview calls repository and reloads',
      build: () {
        when(() => mockRepository.deleteReview(1)).thenAnswer((_) async {});
        when(
          () => mockRepository.getReviewsForGym(1),
        ).thenAnswer((_) async => [testReviews[1]]);
        when(
          () => mockRepository.getAverageRating(1),
        ).thenAnswer((_) async => 5.0);
        when(() => mockRepository.getReviewCount(1)).thenAnswer((_) async => 1);
        return cubit;
      },
      act: (cubit) => cubit.deleteReview(1, 1),
      expect: () => [
        isA<ReviewLoading>(),
        isA<ReviewLoaded>()
            .having((s) => s.reviews.length, 'remaining', 1)
            .having((s) => s.averageRating, 'avg', 5.0),
      ],
    );

    blocTest<ReviewCubit, ReviewState>(
      'loadReviews with empty list shows empty state',
      build: () {
        when(
          () => mockRepository.getReviewsForGym(99),
        ).thenAnswer((_) async => []);
        when(
          () => mockRepository.getAverageRating(99),
        ).thenAnswer((_) async => 0.0);
        when(
          () => mockRepository.getReviewCount(99),
        ).thenAnswer((_) async => 0);
        return cubit;
      },
      act: (cubit) => cubit.loadReviews(99),
      expect: () => [
        isA<ReviewLoading>(),
        isA<ReviewLoaded>()
            .having((s) => s.reviews.isEmpty, 'empty', true)
            .having((s) => s.averageRating, 'avg', 0.0)
            .having((s) => s.reviewCount, 'count', 0),
      ],
    );
  });
}
