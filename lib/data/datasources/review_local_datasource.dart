import '../database/database_helper.dart';
import '../models/review_model.dart';

class ReviewLocalDataSource {
  final DatabaseHelper _databaseHelper;
  static const String _tableName = 'reviews';

  ReviewLocalDataSource({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  Future<List<ReviewModel>> getReviewsForGym(int gymId) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      _tableName,
      where: 'gym_id = ?',
      whereArgs: [gymId],
      orderBy: 'created_at DESC',
    );
    return results.map((map) => ReviewModel.fromMap(map)).toList();
  }

  Future<int> insertReview(ReviewModel review) async {
    final db = await _databaseHelper.database;
    return await db.insert(_tableName, review.toMap());
  }

  Future<int> deleteReview(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getAverageRating(int gymId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT AVG(rating) as avg_rating FROM $_tableName WHERE gym_id = ?',
      [gymId],
    );
    return (result.first['avg_rating'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> getReviewCount(int gymId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName WHERE gym_id = ?',
      [gymId],
    );
    return result.first['count'] as int? ?? 0;
  }
}
