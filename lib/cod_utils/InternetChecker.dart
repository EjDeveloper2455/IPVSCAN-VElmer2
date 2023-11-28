import 'package:connectivity/connectivity.dart';

class InternetChecker {
  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No hay conexión a Internet.
      return false;
    } else if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
      // Hay conexión a Internet a través de Wi-Fi o datos móviles.
      return true;
    } else {
      return false;
    }
  }
}
