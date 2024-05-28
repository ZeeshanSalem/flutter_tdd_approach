import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:games/core/di/presentation_container.dart';
import 'package:games/core/di/remote_container.dart';
import 'package:games/core/network/network_constants.dart';
import 'package:games/core/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../logger/app_logger.dart';
import '../logger/pretty_dio_logger.dart';
import '../network/network_client.dart';
import '../network/network_info.dart';
import '../utils/preferences_util.dart';
import 'domain_container.dart';
import 'injection_container_cache.dart';

final serviceLocator = GetIt.I;

Future<void> initDI() async {
  try {
    serviceLocator.allowReassignment = true;
    // To LOG API Calls (DIO)
    serviceLocator.registerLazySingleton(() => Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 50,
          colors: true,
          printEmojis: true,
          printTime: false,
        )));

    serviceLocator
        .registerLazySingleton(() => AppLogger(logger: serviceLocator()));

    //Initialize NetworkInfo
    serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfo());


    // Initialize DB and Shared preferences.
    await initCacheDI();

    await initDIO();

    initPresentationDI();
    initRemoteDI();
    initDomainDI();

    serviceLocator.registerLazySingleton(() => ScrollController());

    // Network Client.
    serviceLocator.registerLazySingleton(
          () => NetworkClient(
        dio: serviceLocator(),
        logger: serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfo());
  } catch (e, s) {
    debugPrint("Exception in  initDI $e");
    debugPrint("$s");
  }
}

Future<void> initDIO() async {
  try {
    Dio dio = Dio();
    BaseOptions baseOptions = BaseOptions(
        receiveTimeout: const Duration(seconds: 30000),
        // receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
        headers: {
          HttpHeaders.userAgentHeader: 'dio',
          'api': '1.0.0',
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,

        baseUrl: baseUrlApi,
        maxRedirects: 2);

    dio.options = baseOptions;

    dio.interceptors.clear();

    dio.interceptors.add(PrettyDioLogger(
      requestBody: kDebugMode,
      error: kDebugMode,
      request: kDebugMode,
      compact: kDebugMode,
      maxWidth: 90,
      requestHeader: kDebugMode,
      responseBody: kDebugMode,
      responseHeader: kDebugMode,
      // logPrint: (o) {},
    ));



    PreferencesUtil preferences = serviceLocator<PreferencesUtil>();



    dio.interceptors
        .add(QueuedInterceptorsWrapper(onError: (DioException error, handler) async{
          /// @note: this is used for token expiration if they want we will do it.
      // if (error.response?.statusCode == 401 ) {
      //
      //   try {
      //     final loginRepository = serviceLocator<LoginRepository>();
      //     String refreshToken =
      //     preferences.getPreferencesData(kRefreshTokenPref);
      //     RefreshAuthParam refreshAuthParam = RefreshAuthParam(
      //         refreshToken: refreshToken,
      //         responseType: "token",
      //         clientId: Constants.clientId,
      //         grantType: 'refresh_token');
      //
      //     final response = await loginRepository.refreshToken(refreshAuthParam);
      //
      //
      //     response.fold((l) {
      //
      //       _redirectToLoginOnTokenExpiration();
      //
      //       // return;
      //     },
      //             (r) async{
      //
      //           preferences.setPreferencesData(kAccessTokenPref, r.accessToken);
      //           preferences.setPreferencesData(kRefreshTokenPref, r.refreshToken);
      //           final retryResponse = await retry(error.requestOptions);
      //           return    handler.resolve(retryResponse);
      //
      //         });
      //   } catch (e) {
      //
      //     _redirectToLoginOnTokenExpiration();
      //     return handler.next(error);
      //   }
      // }else {
        return handler.next(error);

      // }

    },
        onRequest: (RequestOptions requestOptions, handler) async {
          var accessToken = preferences.getPreferencesData(Constant.kAccessTokenPref);

          if (accessToken != "" || accessToken != null) {
            var authHeader = {'Authorization': 'Bearer $accessToken'};
            requestOptions.headers.addAll(authHeader);
            if (requestOptions.path != "/authorize") {
              // requestOptions.headers
              //     .addAll({"code": preferences.getPreferencesData(requestOptions.path+"_code")});
              // requestOptions.headers
              //     .addAll({"verifier": preferences.getPreferencesData(requestOptions.path+"_verifier")});
            } else {
              // requestOptions.headers
              //     .removeWhere((key, value) => key == "Authorization");
            }
          }
          return handler.next(requestOptions);
        }, onResponse: (response, handler) async {
          return handler.next(response);
        }));

    if (serviceLocator.isRegistered<Dio>()) {
      await serviceLocator.unregister<Dio>();
    }

    serviceLocator.registerLazySingleton(() => dio);
  } catch (e, s) {
    debugPrint("Exception in  initDIO $e");
    debugPrint("$s");
  }


}

// Future<dynamic> retry(RequestOptions requestOptions) async {
//   final dio = serviceLocator<Dio>();
//
//   try {
//     final options = Options(
//       method: requestOptions.method,
//       headers: requestOptions.headers,
//     );
//
//     return dio.request(
//       requestOptions.path,
//       data: requestOptions.data,
//       queryParameters: requestOptions.queryParameters,
//       options: options,
//     );
//   } catch (e) {
//     // _redirectToLoginOnTokenExpiration();
//     return;
//   }
// }


// _redirectToLoginOnTokenExpiration(){
//   final preferences = serviceLocator<PreferencesUtil>();
//   String lastPath = preferences.getPreferencesData(kLastLocationPath);
//   preferences.clearPreferencesData();
//   // Main Purpose of this is to user redirect to same page from
//   // where logout
//   preferences.setPreferencesData(kLastLocationPath, lastPath);
//   Beamer.of(RouteNavigator.navigatorKey.currentContext!).
//   beamToNamed(RouteNavigator.initialRoute,replaceRouteInformation: true, beamBackOnPop: false);
//   // commonSnackBar(
//   //     context: RouteNavigator.scaffoldKey.currentContext!,
//   //     error: ErrorModel(message: "Session is expired."),
//   //     status: SnackBarStatusEnum.failure);
// }