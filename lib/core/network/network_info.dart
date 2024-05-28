import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity _connectivity = Connectivity();
  bool isConnected = true;

  NetworkInfo() {
    checkIsConnected().then((value) => isConnected = value);
  }

  Future<bool> checkIsConnected() async {
    final ConnectivityResult connectivityResult =
    await _connectivity.checkConnectivity();
    return hasAnyConnectivity(connectivityResult);
  }

  StreamSubscription startConnectivityListener() {
    return Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      isConnected = hasAnyConnectivity(result);
    });
  }

  bool hasAnyConnectivity(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.bluetooth:
        return true;
      default:
        return false;
    }
  }
}