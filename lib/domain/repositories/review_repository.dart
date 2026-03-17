import '../entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviewsForGym(int gymId);
  Future<void> addReview(Review review);
  Future<void> deleteReview(int id);
  Future<double> getAverageRating(int gymId);
  Future<int> getReviewCount(int gymId);
}
