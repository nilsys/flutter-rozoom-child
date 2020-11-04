import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rozoom_app/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthToken with ChangeNotifier {
  String authToken = 'No token..........';

  String get getAuthToken => authToken;

  void changeAuthToken(String newAuthToken) {
    authToken = newAuthToken;

    notifyListeners();
  }
}

class Auth with ChangeNotifier {
  String _token;
  // DateTime _expiryDate;

  bool get isAuth {
    // print('isAuth token  ---------------------> $token');
    // print('isAuth -------------$isAuth');
    // notifyListeners();
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(email, password, username) async {
    final String url =
        'https://new.rozoom.co.ua/api/mobile/auth?login=$email&password=$password&name=$username&type_id=1';
    // print(url);
    try {
      final response = await http.post(url);
      // print(response.statusCode);
      final _apiData = json.decode(response.body) as Map<String, dynamic>;
      // print(_apiData);
      if (_apiData == null) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }
      if (_apiData['result'] == false) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }

      if (_apiData['exists'] == true) {
        throw HttpException('Користувач с таким логіном вже існує');
      }

      if (_apiData['exists'] == false &&
          _apiData['authenticated'] == true &&
          _apiData['user']['is_parent'] == 0) {
        // print('SIGNUP SUCCESSFUL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      }
      // print('01 --- ApiData --------------> $_apiData');
      _token = _apiData['api_token'];

      //Локализация
      final String urlLocal =
          'https://new.rozoom.co.ua/api/mobile/me/update?preferred_lang=ua&api_token=$_token';
      final responseLocal = await http.post(urlLocal);
      // print('localization ${responseLocal.body}');
      //

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(email, password) async {
    final String url =
        'https://new.rozoom.co.ua/api/mobile/auth?login=$email&password=$password';
    try {
      // print(url);
      final response = await http.post(url);
      print(response.statusCode);
      final _apiData = json.decode(response.body) as Map<String, dynamic>;
      if (_apiData == null) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }
      if (_apiData['result'] == false) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }

      if (_apiData['exists'] == false) {
        throw HttpException('Користувача с таким логіном не існує');
      }
      if (_apiData['exists'] == true && _apiData['authenticated'] == false) {
        throw HttpException('Невірний пароль');
      }

      if (_apiData['user']['is_parent'] != 0) {
        throw HttpException(
            'Цей логін вже зареєстрований на батьківський акаунт!');
      }
      if (_apiData['exists'] == true &&
          _apiData['authenticated'] == true &&
          _apiData['user']['is_parent'] == 0) {
        // print('LOGIN SUCCESSFUL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      }
      // print('01 --- ApiData --------------> $_apiData');
      _token = _apiData['api_token'];
      // print('sign in token ----------------- $_token');

      // Локализация
      final String urlLocal =
          'https://new.rozoom.co.ua/api/mobile/me/update?preferred_lang=ua&api_token=$_token';
      final responseLocal = await http.post(urlLocal);
      // print('localization ${responseLocal.body}');
      //

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    // print('logout token $_token');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = extractedUserData['token'];
    notifyListeners();
    // _autoLogout();
    return true;
  }
}
