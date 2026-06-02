import '../entities/car_entity.dart';
import '../repositories/car_repository.dart';

class SaveFavoriteUseCase {
  SaveFavoriteUseCase(this._repository);

  final CarRepository _repository;

  Future<void> call(CarEntity car) {
    return _repository.saveFavorite(car);
  }
}
