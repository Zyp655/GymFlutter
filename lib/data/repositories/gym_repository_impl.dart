import '../../domain/entities/gym.dart';
import '../../domain/repositories/gym_repository.dart';
import '../datasources/gym_local_datasource.dart';
import '../models/gym_model.dart';

class GymRepositoryImpl implements GymRepository {
  final GymLocalDataSource _localDataSource;

  GymRepositoryImpl({GymLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? GymLocalDataSourceImpl();

  @override
  Future<List<Gym>> getAllGyms() {
    return _localDataSource.getAllGyms();
  }

  @override
  Future<Gym?> getGymById(int id) {
    return _localDataSource.getGymById(id);
  }

  @override
  Future<List<Gym>> searchGyms(String query) {
    return _localDataSource.searchGyms(query);
  }

  @override
  Future<List<Gym>> filterGyms({double? minRating, List<String>? facilities}) {
    return _localDataSource.filterGyms(
      minRating: minRating,
      facilities: facilities,
    );
  }

  @override
  Future<int> insertGym(Gym gym) {
    final gymModel = GymModel.fromEntity(gym);
    return _localDataSource.insertGym(gymModel);
  }

  @override
  Future<int> updateGym(Gym gym) {
    final gymModel = GymModel.fromEntity(gym);
    return _localDataSource.updateGym(gymModel);
  }

  @override
  Future<int> deleteGym(int id) {
    return _localDataSource.deleteGym(id);
  }

  @override
  Future<void> updateGymRating(int gymId, double rating) {
    return _localDataSource.updateGymRating(gymId, rating);
  }
}
