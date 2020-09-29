import 'package:flutter/widgets.dart';

class AuthToken with ChangeNotifier {
  String authToken = 'No token..........';

  String get getAuthToken => authToken;

  void changeAuthToken(String newAuthToken) {
    authToken = newAuthToken;

    notifyListeners();
  }
}
