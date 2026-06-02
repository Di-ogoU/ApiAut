import '../entities/car_entity.dart';
import '../repositories/car_repository.dart';

class GetCarsUseCase {
  GetCarsUseCase(this._repository);

  final CarRepository _repository;

  Future<List<CarEntity>> call(Map<String, String> filters) {
    return _repository.getCars(filters);
  }
}
