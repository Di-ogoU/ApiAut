import '../entities/car_entity.dart';
import '../repositories/car_repository.dart';

class GetRecommendationsUseCase {
  GetRecommendationsUseCase(this._repository);

  final CarRepository _repository;

  Future<List<CarEntity>> call(String priority, {int limit = 10}) {
    return _repository.getRecommendations(priority, limit);
  }
}
