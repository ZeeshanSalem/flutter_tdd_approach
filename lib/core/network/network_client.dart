import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../error/exception.dart';
import '../logger/app_logger.dart';

class NetworkClient {
  final Dio dio;
  final AppLogger logger;

  NetworkClient(
      {required this.dio, required this.logger,
      });

  Future<Response> invoke(String url, RequestType requestType,
      {Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        dynamic requestBody}) async {
    Response? response;
    try {
      switch (requestType) {
        case RequestType.get:
          response = await dio.get(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
              Options(responseType: ResponseType.json, headers: headers));
          break;
        case RequestType.post:
          response = await dio.post(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
              Options(
                  responseType: ResponseType.json,
                  headers: headers)
          );
          break;
        case RequestType.put:
          response = await dio.put(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
              Options(responseType: ResponseType.json, headers: headers));
          break;
        case RequestType.delete:
          response = await dio.delete(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
              Options(responseType: ResponseType.json, headers: headers));
          break;
        case RequestType.patch:
          response = await dio.patch(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
              Options(responseType: ResponseType.json, headers: headers));
          break;
      }
      return response;
    } on DioException catch (dioError) {

      logger.e('$runtimeType on DioError:-  $dioError', StackTrace.current);
      throw ServerException(dioError: dioError);
    } on SocketException catch (exception) {
      logger.e(
          '$runtimeType on SocketException:-  $exception', StackTrace.current);
      rethrow;
    }
  }
}

// Types used by invoke API.
enum RequestType { get, post, put, delete, patch }