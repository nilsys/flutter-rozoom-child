import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:rozoom_app/core/models/exceptions.dart';
import 'package:rozoom_app/shared/constants.dart';

class ProfileModel {
  String id;
  String name;
  String login;
  String email;
  String phone;
  String birthday;
  String uom;
  String balance;
  String avatarUrl;

  ProfileModel(
      {this.id,
      this.name,
      this.login,
      this.email,
      this.phone,
      this.birthday,
      this.uom,
      this.balance,
      this.avatarUrl});
}

class Profile with ChangeNotifier {
  String authToken;
  String id;

  Profile(this.authToken, this._profileItems);

  Map<String, ProfileModel> _profileItems = {};
  Map<String, ProfileModel> get profileItems => _profileItems;

  bool _isLoadingScreen = false;
  bool get isLoadingScreen => _isLoadingScreen;
  bool _isLoadingWidget = false;
  bool get isLoadingWidget => _isLoadingWidget;

  Map<String, String> get headers =>
      {'Accept': 'text/json', 'Authorization': 'Bearer $authToken'};

  Future<void> apiGetProfileInfo() async {
    const urlSegment = '/api/mobile/me';
    final url = rozoomBaseUrl + urlSegment;

    try {
      _isLoadingScreen = true;
      final response = await http.post(url, headers: headers);
      final extractedData = json.decode(response.body);
      // print('user info --------> $extractedData');
      if (extractedData['error'] != null) {
        throw TokenException();
      }
      parseProfile(extractedData);

      _isLoadingScreen = false;
      notifyListeners();
    } on TokenException catch (error) {
      throw TokenException();
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      throw HttpException('Час сессії закінчився!');
    }
  }

  void parseProfile(Map data) {
    try {
      final String id =
          data['user']['id'] = data['user']['id'].toString() ?? '';
      final String name = data['user']['name'] ??= 'Ім\'я не встановлено.';
      final String login = data['user']['login'] ??= '';
      final String email = data['user']['email'] ??= "Email не встановлено.";
      final String phone = data['user']['phone'] ??= "Телефон не встановлено.";
      final String birthday = data['user']['birthday'] ??= "1900-01-01";
      final String uom =
          data['user']['uom'] = data['user']['uom'].toString() ?? "0";
      final String balance =
          data['user']['balance'] = data['user']['balance'].toString() ?? "0";
      final String avatarUrl = data['user']['avatar_url'] ??=
          "https://rozoom.com.ua/uploads/avatars/eUTzppo49KB3LfOkovsCNcCQk4LBmxCTsMShFlmZ.jpeg";
      Map<String, ProfileModel> loadedProfile = {
        'id': ProfileModel(id: id),
        'name': ProfileModel(name: name),
        'login': ProfileModel(login: login),
        'email': ProfileModel(email: email),
        'phone': ProfileModel(phone: phone),
        'birthday': ProfileModel(birthday: birthday),
        'uom': ProfileModel(uom: uom),
        'balance': ProfileModel(balance: balance),
        'avatarUrl': ProfileModel(avatarUrl: avatarUrl),
      };
      _profileItems = loadedProfile;
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Профайл тимчасово недоступний');
    }
  }

  Future<void> updateUserInfo(param) async {
    final urlSegment = '/api/mobile/me/update?$param';
    final url = rozoomBaseUrl + urlSegment;
    try {
      await http.post(url, headers: headers);
      await apiGetProfileInfo();
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      throw HttpException('Час сессії закінчився!');
    }
  }

  Future<void> sendAvatar(filepath) async {
    Response response;
    Dio dio = new Dio();
    final urlSegment = '/api/mobile/me/update';
    final url = rozoomBaseUrl + urlSegment;
    print(url);
    try {
      FormData formData = new FormData.fromMap({
        "api_token": authToken,
        "avatar":
            await MultipartFile.fromFile(filepath, filename: "avatar.png"),
      });
      response = await dio.post(url, data: formData);
      print(response);
      await apiGetProfileInfo();
    } on HttpException catch (error) {
      print(error);

      throw HttpException(error.toString());
    } catch (error) {
      print(error);
      throw HttpException('Час сессії закінчився!');
    }
  }
}
