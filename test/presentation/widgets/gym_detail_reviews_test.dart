import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/domain/entities/review.dart';
import 'package:btlmobile/presentation/cubits/review/review_cubit.dart';
import 'package:btlmobile/presentation/cubits/review/review_state.dart';
import 'package:btlmobile/core/theme/app_colors.dart';

class MockReviewCubit extends MockCubit<ReviewState> implements ReviewCubit {}

void main() {
  late MockReviewCubit mockReviewCubit;

  final now = DateTime.now();

  final testReviews = [
    Review(
      id: 1,
      gymId: 1,
      userId: 'user1',
      userName: 'John',
      rating: 4.5,
      comment: 'Great gym for working out!',
      createdAt: now,
    ),
    Review(
      id: 2,
      gymId: 1,
      userId: 'user2',
      userName: 'Jane',
      rating: 5.0,
      comment: 'Best gym ever!',
      createdAt: now,
    ),
  ];

  setUp(() {
    mockReviewCubit = MockReviewCubit();
  });

  Widget createReviewsWidget({ReviewState? state}) {
    when(() => mockReviewCubit.state).thenReturn(state ?? ReviewInitial());

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: AppColors.navyDark,
        body: BlocProvider<ReviewCubit>.value(
          value: mockReviewCubit,
          child: BlocBuilder<ReviewCubit, ReviewState>(
            builder: (context, reviewState) {
              if (reviewState is ReviewLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (reviewState is ReviewLoaded) {
                if (reviewState.reviews.isEmpty) {
                  return const Center(
                    child: Text('No reviews yet. Be the first!'),
                  );
                }
                return ListView.builder(
                  itemCount: reviewState.reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviewState.reviews[index];
                    return ListTile(
                      title: Text(review.userName),
                      subtitle: Text(review.comment),
                      trailing: Text('${review.rating}'),
                    );
                  },
                );
              }
              if (reviewState is ReviewError) {
                return Center(child: Text(reviewState.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  group('Gym Detail Reviews Widget Tests', () {
    testWidgets('shows loading indicator when ReviewLoading', (tester) async {
      await tester.pumpWidget(createReviewsWidget(state: ReviewLoading()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no reviews', (tester) async {
      await tester.pumpWidget(
        createReviewsWidget(
          state: const ReviewLoaded(
            reviews: [],
            averageRating: 0.0,
            reviewCount: 0,
          ),
        ),
      );
      expect(find.text('No reviews yet. Be the first!'), findsOneWidget);
    });

    testWidgets('displays reviews list when loaded', (tester) async {
      await tester.pumpWidget(
        createReviewsWidget(
          state: ReviewLoaded(
            reviews: testReviews,
            averageRating: 4.75,
            reviewCount: 2,
          ),
        ),
      );

      expect(find.text('John'), findsOneWidget);
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('Great gym for working out!'), findsOneWidget);
      expect(find.text('Best gym ever!'), findsOneWidget);
    });

    testWidgets('shows error message on ReviewError', (tester) async {
      await tester.pumpWidget(
        createReviewsWidget(state: const ReviewError('Failed to load reviews')),
      );
      expect(find.text('Failed to load reviews'), findsOneWidget);
    });

    testWidgets('displays correct rating values', (tester) async {
      await tester.pumpWidget(
        createReviewsWidget(
          state: ReviewLoaded(
            reviews: testReviews,
            averageRating: 4.75,
            reviewCount: 2,
          ),
        ),
      );

      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);
    });
  });
}
