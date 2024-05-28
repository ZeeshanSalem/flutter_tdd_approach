import 'package:dio/dio.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games/core/di/injection_container_common.dart';
import 'package:games/core/logger/app_logger.dart';

import '../error/exception.dart';
import '../error/models/error_response.dart';
import '../error/models/error_response_model.dart';
import '../utils/preferences_util.dart';




abstract class BaseCubit<State> extends BlocBase<State> {
  /// {@macro cubit}
  BaseCubit(super.initialState);
  AppLogger logger = serviceLocator<AppLogger>();
  PreferencesUtil preferences = serviceLocator<PreferencesUtil>();
  @override
  void emit(State state) {
    if (!isClosed) super.emit(state);
  }

  ErrorModel handleException(Exception exception) {
    String? message = "An Exception has occurred";
    ErrorModel errorModel = ErrorModel(
      message: "An Exception has occurred",
    );
    if (exception is ServerException) {
      /// Here requirement is changed now here we don't need just message;
      return handleDioError(
        exception.dioError,
      );
    } else if (exception is NoInternetException) {
      errorModel.message = "No internet connection available";
    } else if (exception is CubitException) {
      errorModel.message = exception.message ?? message;
    }
    return errorModel;
  }

  handleDioError(
      DioException dioError,
      ) {
    ErrorModel errorModel = ErrorModel();
    switch (dioError.type) {
      case DioExceptionType.cancel:
      // message = "Request was cancelled";
        errorModel.message = "Request was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorModel.message = "Connection timeout";
        break;
      case DioExceptionType.connectionError:
        errorModel.message = "Connection Error";
        break;
      case DioExceptionType.unknown:
        errorModel.message = "Failed to connect with server";
        break;
      case DioExceptionType.receiveTimeout:
        errorModel.message = "Receive timeout in connection";
        break;
      case DioExceptionType.badResponse:
        {
          ErrorResponseModel? responseModel;
          try {
            responseModel =
                ErrorResponseModel.fromJson(dioError.response?.data);
          } catch (e) {
            var error = ErrorResponse.fromJson(dioError.response?.data);
            if (error.error != null) {
              responseModel = ErrorResponseModel(
                  error: ErrorModel(
                      message: error.errorDescription ?? "",
                      code: error.error));
            } else {
              responseModel = ErrorResponseModel(
                  error: ErrorModel(
                    message: "An error has occurred!",
                    code: "-100",
                  ));
            }
          }

          errorModel = ErrorModel(
            message: responseModel.error?.message,
            code: responseModel.error?.code,
            details: responseModel.error?.details,
            validationErrors: responseModel.error?.validationErrors,
          );
          if (dioError.response?.statusCode == 204) {
          } else if (dioError.response?.statusCode == 400) {
            // BadRequestException
            errorModel.message = responseModel.error?.message ?? "BadRequestException";

          } else if (dioError.response?.statusCode == 401) {
            // UnauthorisedException
            errorModel.message = responseModel.error?.message ?? "UnauthorisedException";
          } else if (dioError.response?.statusCode == 403) {
            // ForbiddenException
            errorModel.message = responseModel.error?.message ?? "ForbiddenException";
          } else if (dioError.response?.statusCode == 500) {
            // ServerException
            errorModel.message = responseModel.error?.message ?? "ServerException";
          } else {
            errorModel.message =
            "Received invalid status code: ${dioError.response?.statusCode}";
          }
        }
        break;
      case DioExceptionType.sendTimeout:
        errorModel.message = "Receive timeout in send request_module";
        break;

      case DioExceptionType.badCertificate:
        errorModel.message = "Bed Certificate ";
        break;

    }
    return errorModel;
  }
}