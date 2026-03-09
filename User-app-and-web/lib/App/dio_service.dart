import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hexacom_user/utill/app_constants.dart';

class DioService {
  static Dio? _dio;
  DioService() {
    _dio = Dio();
    _dio!.options.baseUrl = AppConstants.baseUrl;
    _dio!.options.connectTimeout = const Duration(seconds: 60);
    _dio!.options.receiveTimeout = const Duration(seconds: 60);

    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          // Do something before request is sent
          debugPrint('onRequest');
          debugPrint(options.path);
          debugPrint(options.method);
          _dio!.options.headers.putIfAbsent(
              HttpHeaders.acceptHeader, () => Headers.jsonContentType);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('onResponse');
          debugPrint(response.statusCode.toString());
          debugPrint(response.requestOptions.path);
          debugPrint('success: ${response.data['success']}');
          debugPrint('message: ${response.data['message']}');
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          if (error.response?.statusCode == 401) {
            debugPrint(error.response.toString());
            debugPrint(
                'DioError - trying again - ${error.response?.statusCode}');
            debugPrint(error.error.toString() ?? 'NUll from dioerror');
          } else {
            debugPrint(error.response.toString());
            debugPrint(error.response?.statusCode.toString());
            debugPrint(error.message);
          }
          return handler.next(error);
        },
      ),
    );
  }
  static Dio getInstance() {
    if (_dio == null) {
      DioService();
      return _dio!;
    }
    return _dio!;
  }
}
