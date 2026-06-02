import '../repositories/car_repository.dart';

class RemoveFavoriteUseCase {
  RemoveFavoriteUseCase(this._repository);

  final CarRepository _repository;

  Future<void> call(int id) {
    return _repository.removeFavorite(id);
  }
}
