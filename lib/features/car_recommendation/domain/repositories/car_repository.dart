import '../entities/car_entity.dart';

abstract class CarRepository {
  Future<List<CarEntity>> getCars(Map<String, String> filters);

  Future<CarEntity> evaluateCar(Map<String, String> payload);

  Future<List<CarEntity>> getRecommendations(String priority, int limit);

  Future<void> saveHistory(CarEntity car);

  Future<List<CarEntity>> getHistory();

  Future<void> removeHistory(int id);

  Future<void> saveFavorite(CarEntity car);

  Future<List<CarEntity>> getFavorites();

  Future<void> removeFavorite(int id);
}
