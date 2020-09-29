import 'package:flutter/widgets.dart';

class TokenData with ChangeNotifier {
  String _tokenData = 'No token yet.';

  String get getTokenData => _tokenData;

  void changeTokenData(String newTokenData) {
    _tokenData = newTokenData;

    notifyListeners();
  }
}

class ChatTokenData with ChangeNotifier {
  String _tokenData = 'No token yet.';

  String get getTokenData => _tokenData;

  void changeTokenData(String newTokenData) {
    _tokenData = newTokenData;

    notifyListeners();
  }
}

class UserId with ChangeNotifier {
  String _userIdnData = 'No token yet.';

  String get getTokenData => _userIdnData;

  void changeTokenData(String newTokenData) {
    _userIdnData = newTokenData;

    notifyListeners();
  }
}

class UserData with ChangeNotifier {
  String _userData = 'No data yet.';

  String get getUserData => _userData;

  void changeUserData(String newUserData) {
    _userData = newUserData;

    notifyListeners();
  }
}

class MessageCount with ChangeNotifier {
  int _messageCount = 0;

  int get getMessageCount => _messageCount;

  void incrementMessageCount() {
    _messageCount += 1;

    notifyListeners();
  }

  void setToZeroMessageCount() {
    _messageCount = 0;

    notifyListeners();
  }
}

class MyId with ChangeNotifier {
  String _myIdnData = 'No token yet.';

  String get getData => _myIdnData;

  void changeData(String newMyIdnData) {
    _myIdnData = newMyIdnData;

    notifyListeners();
  }
}
