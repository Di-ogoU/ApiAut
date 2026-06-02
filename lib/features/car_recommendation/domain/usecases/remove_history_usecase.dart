import '../repositories/car_repository.dart';

class RemoveHistoryUseCase {
  RemoveHistoryUseCase(this._repository);

  final CarRepository _repository;

  Future<void> call(int id) {
    return _repository.removeHistory(id);
  }
}
