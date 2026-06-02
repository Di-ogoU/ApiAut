import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class DioClient {
  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  final Dio dio;
}
