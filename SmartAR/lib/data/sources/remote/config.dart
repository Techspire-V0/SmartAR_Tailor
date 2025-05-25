import 'dart:io';

import 'package:SmartAR/core/services/token_storage.dart';
import 'package:SmartAR/core/types/auth.dart';
import 'package:SmartAR/data/consts.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ReqHandler {
  final List<Dio> _instances = [];

  bool _isRefreshing = false;
  Future<Response>? _refreshFuture;

  final Dio _baseDio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  void _handleBearerToken(JwtToken tokens) {
    // Update headers on all instances
    tokenStorage.saveTokens(tokens);

    for (var instance in _instances) {
      instance.options.headers['Authorization'] =
          'Bearer ${tokens.accessToken}';
    }
  }

  APIRes<T> _serviceUnavailable<T>() {
    return APIRes<T>(
      status: APIStatus(
        code: StatusCode.network,
        message: 'Service Unavailable – Please try again later',
        success: false,
      ),
    );
  }

  APIRes<T> _handleTimeout<T>() {
    return APIRes<T>(
      status: APIStatus(
        code: StatusCode.timeout,
        message:
            'Your request took too long to process. Please check your connection and try again.',
        success: false,
      ),
    );
  }

  APIRes<T> _processResponse<T>(Response response) {
    final returnedCode = response.statusCode ?? 500;
    final code =
        returnedCode >= 200 && returnedCode <= 299 ? 200 : returnedCode;

    return APIRes(
      data: response.data,
      status: APIStatus(
        code: code,
        message: response.data?.message ?? response.statusMessage ?? 'Success',
        success: code == 200,
      ),
    );
  }

  Future<APIRes<dynamic>> _handleRefreshToken(
    RequestOptions originalRequest,
    Dio instance,
    APIRes<dynamic> prevStatus,
  ) async {
    if (prevStatus.status.code == 401 &&
        originalRequest.extra['_retry'] != true) {
      if (!_isRefreshing) {
        _isRefreshing = true;

        try {
          _refreshFuture = _baseDio.post<Map<String, dynamic>>(
            '/api/auth/refresh-token',
          );

          final refreshResponse = await _refreshFuture!;
          final APIRes<JwtToken> authRes = refreshResponse.data!;

          // Add access token to instances header
          _handleBearerToken(authRes.data as JwtToken);

          // Retry the original request
          originalRequest.extra['_retry'] = true;
          final res = await instance.fetch(originalRequest);

          _isRefreshing = false;
          _refreshFuture = null;

          return res.data as APIRes<dynamic>;
        } catch (refreshError) {
          // Reset auth state - integrate with your state management
          tokenStorage.logout();
          _isRefreshing = false;
          _refreshFuture = null;
        }
      } else {
        // Wait for refresh to complete
        try {
          await _refreshFuture;

          originalRequest.extra['_retry'] = true;
          final response = await instance.fetch(originalRequest);
          return response.data as APIRes<dynamic>;
        } catch (error) {
          return prevStatus;
        }
      }
    }
    return prevStatus;
  }

  Dio createHttpClient(
    String subUrl, {
    bool useRefresh = true,
    Map<String, String>? customHeaders,
  }) {
    final options = BaseOptions(
      baseUrl: '$baseApiUrl$subUrl',
      connectTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    final dio = Dio(options);

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => host == apiHost;
      return client;
    };

    // Add interceptors (response & error handling)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {
          // Consider 2xx as success
          final processedResponse = _processResponse(response);

          // Transform the response data to APIRes format
          final apiResponse = Response(
            data: processedResponse,
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            headers: response.headers,
          );
          handler.resolve(apiResponse);
        },
        onError: (error, handler) async {
          APIRes? errorResponse;

          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            errorResponse = _handleTimeout();
          } else if (error.type == DioExceptionType.connectionError) {
            errorResponse = _serviceUnavailable();
          } else {
            final code = error.response!.statusCode ?? 500;
            final statusCode =
                code >= StatusCode.success && code <= 299
                    ? StatusCode.success
                    : code;

            final message = error.response!.data ?? 'Internal Server error';

            errorResponse = APIRes(
              status: APIStatus(
                message: message,
                code: statusCode,
                success: false,
              ),
            );

            if (useRefresh) {
              errorResponse = await _handleRefreshToken(
                error.requestOptions,
                dio,
                errorResponse,
              );
            }
          }

          final apiResponse = Response(
            data: errorResponse,
            requestOptions: error.requestOptions,
            statusCode: errorResponse.status.code,
            statusMessage: errorResponse.status.message,
          );
          handler.resolve(apiResponse);
        },
      ),
    );

    _instances.add(dio);
    return dio;
  }
}
