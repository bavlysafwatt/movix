import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movix/core/api/status_code.dart';
import 'package:movix/dependency_injection.dart';

import '../error/exceptions.dart';
import 'api_consumer.dart';
import 'app_interceptors.dart';
import 'end_points.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..connectTimeout = const Duration(seconds: 25)
      ..followRedirects = false
      ..validateStatus = (status) {
        return status != null && status >= 200 && status < 300;
      };
    client.interceptors.add(getIt<AppInterceptors>());
    if (kDebugMode) {
      client.interceptors.add(getIt<LogInterceptor>());
    }
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(path, queryParameters: queryParameters);
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(
    String path, {
    Map<String, dynamic>? body,
    bool formDataIsEnabled = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.post(
        path,
        queryParameters: queryParameters,
        data: formDataIsEnabled ? FormData.fromMap(body!) : body,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.put(
        path,
        queryParameters: queryParameters,
        data: body,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.patch(
        path,
        queryParameters: queryParameters,
        data: body,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.delete(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future uploadFile(
      String path,
      String filePath, {
        Map<String, dynamic>? headers,
      }) async {
    try {
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      // Read the exact bytes that will be sent
      final bytes = await File(filePath).readAsBytes();
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
      });

      final response = await client.post(
        path,
        data: formData,
        options: Options(headers: headers),
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleResponseAsJson(Response<dynamic> response) {
    final data = response.data;
    if (data == null || data.toString().trim().isEmpty) return null;
    return jsonDecode(data.toString());
  }

  dynamic _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;

      if (statusCode == StatusCode.tooManyRequests) {
        throw const TooManyRequestsException();
      }

      final data = error.response?.data;
      String message = 'Something went wrong, try again later.';

      if (data != null) {
        try {
          final decoded = jsonDecode(data.toString());
          message =
              decoded['status_message'] ??
              decoded['message'] ??
              decoded['error'] ??
              decoded['detail'] ??
              message;
        } catch (_) {
          if (data is String && data.isNotEmpty) {
            message = data;
          }
        }
      }

      if (statusCode != null && statusCode >= StatusCode.internalServerError) {
        throw InternalServerErrorException(message);
      }

      throw GenericException(message: message);
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        throw const FetchDataException();

      case DioExceptionType.connectionError:
        throw const NoInternetConnectionException();

      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          throw const NoInternetConnectionException();
        }
        throw const InternalServerErrorException();
    }
  }
}
