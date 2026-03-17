import '../entities/gym.dart';
import '../repositories/gym_repository.dart';

class GetAllGyms {
  final GymRepository _repository;

  GetAllGyms(this._repository);

  Future<List<Gym>> call() {
    return _repository.getAllGyms();
  }
}

class GetGymById {
  final GymRepository _repository;

  GetGymById(this._repository);

  Future<Gym?> call(int id) {
    return _repository.getGymById(id);
  }
}

class SearchGyms {
  final GymRepository _repository;

  SearchGyms(this._repository);

  Future<List<Gym>> call(String query) {
    return _repository.searchGyms(query);
  }
}

class FilterGyms {
  final GymRepository _repository;

  FilterGyms(this._repository);

  Future<List<Gym>> call({double? minRating, List<String>? facilities}) {
    return _repository.filterGyms(minRating: minRating, facilities: facilities);
  }
}
