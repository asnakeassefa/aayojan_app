// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@injectable
class CheckInternet {

  Future<bool> hasInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }
}
