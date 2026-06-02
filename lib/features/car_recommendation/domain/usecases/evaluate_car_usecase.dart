import '../entities/car_entity.dart';
import '../repositories/car_repository.dart';

class EvaluateCarUseCase {
  EvaluateCarUseCase(this._repository);

  final CarRepository _repository;

  Future<CarEntity> call(Map<String, String> payload) {
    return _repository.evaluateCar(payload);
  }
}
