import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:rozoom_app/models/api.dart';
import 'package:rozoom_app/models/http_exception.dart';

class Profile with ChangeNotifier {
  String authToken;
  String name;
  String email;
  String phone;
  String birthday;
  String balance;
  String certificates;
  String avatarUrl;

  Profile(this.authToken,
      {this.name,
      this.email,
      this.phone,
      this.birthday,
      this.certificates,
      this.avatarUrl});

  get getName => name;
  get getEmail => email;
  get getPhone => phone;
  get getBirthday => birthday;
  get getBalance => balance;
  get getCertificates => certificates;
  get getAvatarUrl => avatarUrl;

  Future<void> getProfileInfo() async {
    print('get profile auth token ---------------------------- $authToken');
    final url = 'https://rozoom.com.ua/api/mobile/me';
    try {
      final data = {'api_token': authToken};
      final response = await apiRequest(url, data);

      final extractedData = json.decode(response.body);
      print('user info --------> $extractedData');
      if (extractedData['error'] != null) {
        throw HttpException('Час сессіЇ вичерпано');
      }

      print('user info --------> $extractedData');
      name = extractedData['user']['name'] != null
          ? extractedData['user']['name']
          : "Ім'я не встановлено.";
      email = extractedData['user']['email'] != null
          ? extractedData['user']['email']
          : "Email не встановлено.";
      phone = extractedData['user']['phone'] != null
          ? extractedData['user']['phone']
          : "Телефон не встановлено.";

      birthday = extractedData['user']['birthday'] != null
          ? extractedData['user']['birthday']
          : "1900-01-01";
      balance = extractedData['user']['uom'] != null
          ? extractedData['user']['uom']
          : "0";
      certificates = extractedData['user']['balance'] != null
          ? extractedData['user']['balance']
          : "0";
      avatarUrl = extractedData['user']['avatar_url'] != null
          ? extractedData['user']['avatar_url']
          : "https://rozoom.com.ua/images/design/brand.svg";
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateUserInfo(param) async {
    print('update profile auth token ---------------------------- $authToken');
    final url = 'https://rozoom.com.ua/api/mobile/me/update?$param';
    try {
      final data = {'api_token': authToken};
      await http.post(url, body: data);
      await getProfileInfo();
    } catch (error) {
      throw error;
    }
  }

  Future<void> sendAvatar(filepath) async {
    Response response;
    Dio dio = new Dio();
    print('send avatar auth token ---------------------------- $authToken');
    final url = 'https://rozoom.com.ua/api/mobile/me/update';
    try {
      FormData formData = new FormData.fromMap({
        "api_token": authToken,
        "avatar":
            await MultipartFile.fromFile(filepath, filename: "avatar.png"),
      });
      response = await dio.post(url, data: formData);
      print(response);
      await getProfileInfo();
    } catch (error) {
      throw error;
    }
  }
}
