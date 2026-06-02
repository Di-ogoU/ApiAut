import 'package:dio/dio.dart';

import '../../domain/entities/car_entity.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_local_data_source.dart';
import '../datasources/car_remote_data_source.dart';
import '../models/car_model.dart';

class CarRepositoryImpl implements CarRepository {
  CarRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final CarRemoteDataSource _remoteDataSource;
  final CarLocalDataSource _localDataSource;

  @override
  Future<List<CarEntity>> getCars(Map<String, String> filters) async {
    try {
      return await _remoteDataSource.getCars(filters);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  @override
  Future<CarEntity> evaluateCar(Map<String, String> payload) async {
    try {
      return await _remoteDataSource.evaluateCar(payload);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  @override
  Future<List<CarEntity>> getRecommendations(String priority, int limit) async {
    try {
      return await _remoteDataSource.getRecommendations(priority, limit);
    } on DioException catch (error) {
      throw Exception(_messageFromDio(error));
    }
  }

  @override
  Future<void> saveHistory(CarEntity car) {
    return _localDataSource.saveHistory(CarModel.fromEntity(car));
  }

  @override
  Future<List<CarEntity>> getHistory() {
    return _localDataSource.getHistory();
  }

  @override
  Future<void> removeHistory(int id) {
    return _localDataSource.deleteHistory(id);
  }

  @override
  Future<void> saveFavorite(CarEntity car) {
    return _localDataSource.saveFavorite(CarModel.fromEntity(car));
  }

  @override
  Future<List<CarEntity>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  @override
  Future<void> removeFavorite(int id) {
    return _localDataSource.deleteFavorite(id);
  }

  String _messageFromDio(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['detail'] != null) {
      return data['detail'].toString();
    }
    return 'No fue posible conectar con la API.';
  }
}
