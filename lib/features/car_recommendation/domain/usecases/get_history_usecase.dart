import '../entities/car_entity.dart';
import '../repositories/car_repository.dart';

class GetHistoryUseCase {
  GetHistoryUseCase(this._repository);

  final CarRepository _repository;

  Future<List<CarEntity>> call() {
    return _repository.getHistory();
  }
}
