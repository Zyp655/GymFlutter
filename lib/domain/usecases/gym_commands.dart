import '../entities/gym.dart';
import '../repositories/gym_repository.dart';

class InsertGym {
  final GymRepository _repository;

  InsertGym(this._repository);

  Future<int> call(Gym gym) {
    return _repository.insertGym(gym);
  }
}

class UpdateGym {
  final GymRepository _repository;

  UpdateGym(this._repository);

  Future<int> call(Gym gym) {
    return _repository.updateGym(gym);
  }
}

class DeleteGym {
  final GymRepository _repository;

  DeleteGym(this._repository);

  Future<int> call(int id) {
    return _repository.deleteGym(id);
  }
}
