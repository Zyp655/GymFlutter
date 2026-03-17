import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/app_logger.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/repositories/gym_repository.dart';
import '../../../domain/repositories/review_repository.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _reviewRepository;
  final GymRepository _gymRepository;

  ReviewCubit({
    required ReviewRepository reviewRepository,
    required GymRepository gymRepository,
  }) : _reviewRepository = reviewRepository,
       _gymRepository = gymRepository,
       super(ReviewInitial());

  Future<void> loadReviews(int gymId) async {
    emit(ReviewLoading());
    try {
      final reviews = await _reviewRepository.getReviewsForGym(gymId);
      final avgRating = await _reviewRepository.getAverageRating(gymId);
      final count = await _reviewRepository.getReviewCount(gymId);

      emit(
        ReviewLoaded(
          reviews: reviews,
          averageRating: avgRating,
          reviewCount: count,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.e('Error loading reviews', e, stackTrace);
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> addReview({
    required int gymId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    try {
      final review = Review(
        gymId: gymId,
        userId: userId,
        userName: userName,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
      await _reviewRepository.addReview(review);
      await _syncGymRating(gymId);
      await loadReviews(gymId);
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> deleteReview(int reviewId, int gymId) async {
    try {
      await _reviewRepository.deleteReview(reviewId);
      await _syncGymRating(gymId);
      await loadReviews(gymId);
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _syncGymRating(int gymId) async {
    final avgRating = await _reviewRepository.getAverageRating(gymId);
    await _gymRepository.updateGymRating(gymId, avgRating);
  }
}
