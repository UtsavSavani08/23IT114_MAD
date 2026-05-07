import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  late final Dio _dio;
  static const String _baseUrl = 'https://api.careerforge.mock/v1'; // Mock URL

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Future<void> postResumes(List<dynamic> resumes) async {
    try {
      await _dio.post('/resumes', data: resumes);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postApplications(List<dynamic> applications) async {
    try {
      await _dio.post('/applications', data: applications);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getApplications() async {
    try {
      final response = await _dio.get('/applications');
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
