import '../entities/gym.dart';

abstract class GymRepository {
  Future<List<Gym>> getAllGyms();
  Future<Gym?> getGymById(int id);
  Future<List<Gym>> searchGyms(String query);
  Future<List<Gym>> filterGyms({double? minRating, List<String>? facilities});
  Future<int> insertGym(Gym gym);
  Future<int> updateGym(Gym gym);
  Future<int> deleteGym(int id);
  Future<void> updateGymRating(int gymId, double rating);
}
