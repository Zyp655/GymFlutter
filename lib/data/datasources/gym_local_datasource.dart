import '../../core/constants/app_constants.dart';
import '../database/database_helper.dart';
import '../models/gym_model.dart';

abstract class GymLocalDataSource {
  Future<List<GymModel>> getAllGyms();
  Future<GymModel?> getGymById(int id);
  Future<List<GymModel>> searchGyms(String query);
  Future<List<GymModel>> filterGyms({
    double? minRating,
    List<String>? facilities,
  });
  Future<int> insertGym(GymModel gym);
  Future<int> updateGym(GymModel gym);
  Future<int> deleteGym(int id);
  Future<void> updateGymRating(int gymId, double rating);
}

class GymLocalDataSourceImpl implements GymLocalDataSource {
  final DatabaseHelper _databaseHelper;

  GymLocalDataSourceImpl({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<GymModel>> getAllGyms() async {
    final maps = await _databaseHelper.queryAll(AppConstants.gymTable);
    return maps.map((map) => GymModel.fromMap(map)).toList();
  }

  @override
  Future<GymModel?> getGymById(int id) async {
    final map = await _databaseHelper.queryById(AppConstants.gymTable, id);
    return map != null ? GymModel.fromMap(map) : null;
  }

  @override
  Future<List<GymModel>> searchGyms(String query) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.gymTable,
      where:
          '${AppConstants.colName} LIKE ? OR ${AppConstants.colAddress} LIKE ? OR ${AppConstants.colDescription} LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((map) => GymModel.fromMap(map)).toList();
  }

  @override
  Future<List<GymModel>> filterGyms({
    double? minRating,
    List<String>? facilities,
  }) async {
    final db = await _databaseHelper.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (minRating != null) {
      whereClause = '${AppConstants.colRating} >= ?';
      whereArgs.add(minRating);
    }

    if (facilities != null && facilities.isNotEmpty) {
      final facilityConditions = facilities
          .map((_) => '${AppConstants.colFacilities} LIKE ?')
          .join(' AND ');

      if (whereClause.isNotEmpty) {
        whereClause += ' AND ($facilityConditions)';
      } else {
        whereClause = facilityConditions;
      }

      whereArgs.addAll(facilities.map((f) => '%$f%'));
    }

    final maps = await db.query(
      AppConstants.gymTable,
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return maps.map((map) => GymModel.fromMap(map)).toList();
  }

  @override
  Future<int> insertGym(GymModel gym) async {
    return await _databaseHelper.insert(AppConstants.gymTable, gym.toMap());
  }

  @override
  Future<int> updateGym(GymModel gym) async {
    if (gym.id == null) {
      throw Exception('Cannot update gym without an ID');
    }
    return await _databaseHelper.update(
      AppConstants.gymTable,
      gym.toMap(),
      gym.id!,
    );
  }

  @override
  Future<int> deleteGym(int id) async {
    return await _databaseHelper.delete(AppConstants.gymTable, id);
  }

  @override
  Future<void> updateGymRating(int gymId, double rating) async {
    final db = await _databaseHelper.database;
    await db.update(
      AppConstants.gymTable,
      {AppConstants.colRating: rating},
      where: '${AppConstants.colId} = ?',
      whereArgs: [gymId],
    );
  }
}
