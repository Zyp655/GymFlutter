import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_local_datasource.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewLocalDataSource _localDataSource;

  ReviewRepositoryImpl({ReviewLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? ReviewLocalDataSource();

  @override
  Future<List<Review>> getReviewsForGym(int gymId) async {
    return await _localDataSource.getReviewsForGym(gymId);
  }

  @override
  Future<void> addReview(Review review) async {
    final model = ReviewModel.fromEntity(review);
    await _localDataSource.insertReview(model);
  }

  @override
  Future<void> deleteReview(int id) async {
    await _localDataSource.deleteReview(id);
  }

  @override
  Future<double> getAverageRating(int gymId) async {
    return await _localDataSource.getAverageRating(gymId);
  }

  @override
  Future<int> getReviewCount(int gymId) async {
    return await _localDataSource.getReviewCount(gymId);
  }
}
