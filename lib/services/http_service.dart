// http_service.dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpService {
  late Dio _dio;

  final baseUrl = "http://192.168.18.165/backend/";

  HttpService() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    initializeInterceptors();
  }

  Future<Response> getRequest(String endPoint) async {
    try {
      return await _dio.get(endPoint);
    } catch (e) {
      rethrow; // Rethrow the exception for handling in the calling function
    }
  }

  void initializeInterceptors() {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }
}
