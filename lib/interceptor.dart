import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_fakestore_app/storage.dart';

class AuthInterceptor extends Interceptor {
  final GlobalKey<NavigatorState> navigatorKey;
  final Storage storage;
  AuthInterceptor(this.navigatorKey, this.storage);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await storage.read('accessToken');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      } else {
        _redirectToLogin();
        handler.reject(DioException(
          requestOptions: options,
          error: 'No token found',
          type: DioExceptionType.cancel,
        ));
      }
    } catch (e) {
      _redirectToLogin();
      handler.reject(DioException(
        requestOptions: options,
        error: 'Token error',
        type: DioExceptionType.cancel,
      ));
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {}

  void _redirectToLogin() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
    navigatorKey.currentState?.pushReplacementNamed('/login');
  }
}
