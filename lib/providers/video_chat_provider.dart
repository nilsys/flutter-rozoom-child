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
    final url = 'https://rozoom.com.ua/api/me/conference?api_token=$authToken';
    print('url-------------------------> $url');

    try {
      final response = await http.get(url);
      print('response-------------------------> $response');
      // print('response-------------------------> ${response['conference']}');
      final responseDataEncode = json.encode(response.body);
      print('video chat get name responseDataEncode: $responseDataEncode');
      final responseDataDecode = json.decode(responseDataEncode);
      print('video chat get name responseDataDecode: $responseDataDecode');
      final responseData = json.decode(response.body);
      print('video chat get name response data: $responseData');
      _videoChatName = responseData['conference'];
      print('-------------------------name vchat ->$_videoChatName');
      notifyListeners();
    } catch (error) {
      print('video chat get name error: $error');
    }
  }
}
