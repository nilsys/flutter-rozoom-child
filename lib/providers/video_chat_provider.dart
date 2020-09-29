import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VideoChat extends ChangeNotifier {
  String authToken;
  String get getAuthToken => authToken;
  set setAuthToken(String value) {
    authToken = value;
  }

  String _videoChatName;
  String get videoChatName => _videoChatName;

  Future<void> getVideoChatName() async {
    final url = 'https://rozoom.co.ua/api/me/conference?api_token=$authToken';

    try {
      final response = await http.post(url);
      final responseData = json.decode(response.body);
      print('video chat get name response data: $responseData');
      _videoChatName = responseData['conference'];
      notifyListeners();
    } catch (error) {
      print('video chat get name error: $error');
    }
  }
}
