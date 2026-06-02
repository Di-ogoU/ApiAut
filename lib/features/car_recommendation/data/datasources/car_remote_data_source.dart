import 'package:dio/dio.dart';

import '../models/car_model.dart';

class CarRemoteDataSource {
  CarRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CarModel>> getCars(Map<String, String> filters) async {
    final response = await _dio.get('/cars', queryParameters: filters);
    final items = (response.data['items'] as List<dynamic>)
        .map((item) => CarModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return items;
  }

  Future<CarModel> evaluateCar(Map<String, String> payload) async {
    final response = await _dio.post('/evaluate', data: payload);
    return CarModel.fromJson(response.data['item'] as Map<String, dynamic>);
  }

  Future<List<CarModel>> getRecommendations(String priority, int limit) async {
    final response = await _dio.get(
      '/recommendations',
      queryParameters: {'priority': priority, 'limit': limit},
    );
    final items = (response.data['items'] as List<dynamic>)
        .map((item) => CarModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return items;
  }
}
