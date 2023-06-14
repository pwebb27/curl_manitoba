import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImp implements NetworkInfo {
  final ConnectivityResult connectivityResult;

  NetworkInfoImp(this.connectivityResult);

  @override
  Future<bool> get isConnected =>
      Connectivity().checkConnectivity().then((connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          return Future.value(true);
        }
        return Future.value(false);
      });
}
