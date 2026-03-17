import '../database/database_helper.dart';

class FavoritesLocalDataSource {
  final DatabaseHelper _databaseHelper;

  static const String _tableName = 'favorites';
  static const String _colGymId = 'gym_id';
  static const String _colCreatedAt = 'created_at';

  FavoritesLocalDataSource({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  Future<List<int>> getFavoriteIds() async {
    final db = await _databaseHelper.database;
    final results = await db.query(_tableName);
    return results.map((row) => row[_colGymId] as int).toList();
  }

  Future<bool> isFavorite(int gymId) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      _tableName,
      where: '$_colGymId = ?',
      whereArgs: [gymId],
    );
    return results.isNotEmpty;
  }

  Future<void> addFavorite(int gymId) async {
    final db = await _databaseHelper.database;
    await db.insert(_tableName, {
      _colGymId: gymId,
      _colCreatedAt: DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFavorite(int gymId) async {
    final db = await _databaseHelper.database;
    await db.delete(_tableName, where: '$_colGymId = ?', whereArgs: [gymId]);
  }

  Future<void> toggleFavorite(int gymId) async {
    final isFav = await isFavorite(gymId);
    if (isFav) {
      await removeFavorite(gymId);
    } else {
      await addFavorite(gymId);
    }
  }
}
