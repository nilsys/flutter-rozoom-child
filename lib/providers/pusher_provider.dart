import 'dart:convert';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:rozoom_app/providers/friend_provider.dart';

class Pusher with ChangeNotifier {
  String authToken;
  Pusher(this.authToken);

  Map<String, dynamic> _apiMessagesData;
  String pusherToken;
  String myId;
  bool isActive = false;

  int totalUnreadMessages = 0;
  int get getTotalUnreadMessages => totalUnreadMessages;

  List<Friend> _friendList = [];
  List<Friend> get friendList {
    return [..._friendList];
  }

  List<Message> _friendChatList = [];
  List<Message> get friendChatList {
    return [..._friendChatList];
  }

  // void changeAuthToken(String newAuthToken) {
  //   authToken = newAuthToken;

  //   notifyListeners();
  // }

  Future<void> initPusher() async {
    try {
      var options = PusherOptions(
        cluster: 'eu',
        encrypted: true,
        auth: PusherAuth(
          'https://rozoom.com.ua/broadcasting/auth?api_token=$authToken',
          headers: {'X-CSRF-Token': pusherToken},
        ),
      );
      FlutterPusher pusher = FlutterPusher(
        '1ac3495cdf6d490ab1f7',
        options,
        enableLogging: true,
      );
      Echo echo = new Echo({
        'broadcaster': 'pusher',
        'client': pusher,
      });

      echo.private('chat.$myId').listen('.chat-message', (event) async {
        // addMessage(
        //     event['id'],
        //     event['user_id'],
        //     event['body'],
        //     event['status_id'],
        //     event['created_at'],
        //     event['my'],
        //     event['conference_room']);
        await getApiData();
        await getApiFriends();
        // _apiMessagesData['friends'][event]
        // getApiData();
        return getApiFriendChat((event['user_id']).toString());
        // getApiFriendChat();
      });
    } catch (error) {
      print('pusher error ------------------> $error');
      throw (error);
    }
    notifyListeners();
  }

  Future<void> initPusher2(String friendId) async {
    try {
      var options = PusherOptions(
        cluster: 'eu',
        encrypted: true,
        auth: PusherAuth(
          'https://rozoom.com.ua/broadcasting/auth?api_token=$authToken',
          headers: {'X-CSRF-Token': pusherToken},
        ),
      );
      FlutterPusher pusher = FlutterPusher(
        '1ac3495cdf6d490ab1f7',
        options,
        enableLogging: true,
      );
      Echo echo = new Echo({
        'broadcaster': 'pusher',
        'client': pusher,
      });

      await readAllMessages(friendId);

      echo.private('chat.$myId').listen('.chat-message', (event) async {
        if (event['user_id'].toString() == friendId) {
          var data = {'id': event['id'].toString()};
          await readOneMessage(data, friendId);
        }
        if (event['body'] == 'close') {
          echo.disconnect();
          print(echo.options);
          print('disconnected');
        }

        await getApiData();
        await getApiFriends();
        // _apiMessagesData['friends'][event]
        // getApiData();
        return getApiFriendChat((event['user_id']).toString());
        // getApiFriendChat();
      });
    } catch (error) {
      print('pusher2 error ------------------> $error');
      throw (error);
    }
    notifyListeners();
  }

  Future<void> getApiData() async {
    final url = 'https://rozoom.com.ua/api/me/chat?api_token=$authToken';
    // print('-------------------------token provider auth $rozoomToken');
    try {
      final response = await http.post(url);
      final responseData = json.decode(response.body);
      _apiMessagesData = responseData;
      pusherToken = responseData['csrf'];
      totalUnreadMessages = responseData['unread'];
      myId = responseData['me']['id'].toString();
      print('api data ---------------------------------> $_apiMessagesData');
    } catch (error) {
      print('getApiData error: $error');
    }
    notifyListeners();
  }

  Future<void> getApiFriends() async {
    List _apiData = _apiMessagesData['friends'];
    // print('_apiData+++++++++++++++++++++++>>>>>>>>>$_apiData');

    final List<Friend> loadedFriends = [];
    for (var i = 0; i < _apiData.length; i++) {
      int unreadMessagesCount = 0;
      for (var k = 0; k < (_apiData[i]['messages']).length; k++) {
        // print('--------------------------${(_apiData[i]['messages'].length)}');
        // print('--------------------------${(_apiData[i]['messages'][k])}');

        if (_apiData[i]['messages'][k]['status_id'] == 2) {
          if (_apiData[i]['messages'][k]['my'] == false) {
            unreadMessagesCount += 1;
          }
        }
      }
      loadedFriends.add(
        Friend(
          id: _apiData[i]['id'].toString(),
          name: _apiData[i]['name'],
          avatarUrl: _apiData[i]['avatar_url'],
          lastMessage: _apiData[i]['messages'].last['body'],
          messageTime: _apiData[i]['messages'].last['created_at'].toString(),
          unreadMessages: unreadMessagesCount,
          lastActivity: (_apiData[i]['last_activity'] != null)
              ? DateTime.parse(_apiData[i]['last_activity'])
              : DateTime.parse("1982-01-18 15:15:15"),
          onlineStatus: (_apiData[i]['last_activity'] != null &&
                  DateTime.now()
                          .difference(
                              DateTime.parse(_apiData[i]['last_activity']))
                          .inSeconds <
                      600)
              ? true
              : false,
        ),
      );
      print(
          'online--------------------${loadedFriends[i].name}------------------------> ${loadedFriends[i].onlineStatus}');
    }
    _friendList = loadedFriends;
    // print(
    //     '_friendList ---------------------------------> ${_friendList.first}');
    // print('------->$_friendList');
    notifyListeners();
  }

  Future<void> getApiFriendChat(String friendId) async {
    // final url = 'https://rozoom.co.ua/api/me/chat?api_token=$authToken';
    try {
      // final response = await http.post(url);
      // final responseData = json.decode(response.body);
      // _apiMessagesData = responseData;
      // final List<Friend> _newFriendList = _friendList;

      // print(
      //     'int.parse---888888888888888888888888888888888${int.parse(friendId)}');
      // _newFriendList[int.parse(friendId)].unreadMessages = 0;
      List _apiData = _apiMessagesData['friends'];
      // print('_apiData+++++++++++++++++++++++>>>>>>>>>$_apiData');
      List _extractedFriendList = [];
      for (var i = 0; i < _apiData.length; i++) {
        // if (_newFriendList[i].id.toString() == friendId) {
        //   _newFriendList[i].unreadMessages = 0;
        // }
        // print(
        //     'newFriendList----888888888888888888888888888888888${_newFriendList[i].id}');
        if ((_apiData[i]['id']).toString() == friendId) {
          _extractedFriendList.add(_apiData[i]['messages']);
        }
      }
      final List<Message> loadedFriendChat = [];
      _extractedFriendList = _extractedFriendList[0];
      for (var i = 0; i < _extractedFriendList.length; i++) {
        loadedFriendChat.add(
          Message(
            id: _extractedFriendList[i]['id'].toString(),
            userId: _extractedFriendList[i]['user_id'].toString(),
            body: _extractedFriendList[i]['body'] ?? '',
            statusId: _extractedFriendList[i]['status_id'].toString(),
            createdAt: _extractedFriendList[i]['created_at'],
            my: _extractedFriendList[i]['my'],
            conferenceRoom: _extractedFriendList[i]['conference_room'],
          ),
        );
      }

      _friendChatList = loadedFriendChat;
      // print(
      //     '_friendChatList ---------------------------------> ${_friendChatList.first}');
      notifyListeners();
    } catch (error) {
      print('getApiData error: $error');
    }
  }

  Future<void> readOneMessage(data, friendId) async {
    final url = 'https://rozoom.com.ua/api/me/chat/read?api_token=$authToken';

    try {
      final response = await http.post(url, body: data);
      final responseData = json.decode(response.body);
      print('Read message -> api response: $responseData');
    } catch (error) {
      print('Read message -> api error: $error');
    }
    await getApiData();
    await getApiFriends();
    await getApiFriendChat(friendId);
    notifyListeners();
  }

  Future<void> readAllMessages(String friendId) async {
    final url = 'https://rozoom.com.ua/api/me/chat/read?api_token=$authToken';
    try {
      List _apiData = _apiMessagesData['friends'];
      List _unreadMessages = [];
      for (var i = 0; i < _apiData.length; i++) {
        if ((_apiData[i]['id']).toString() == friendId) {
          _unreadMessages = _apiData[i]['unread'];
        }
      }
      // print('-unread messages ------------------> $_unreadMessages');
      if (_unreadMessages != null) {
        for (var i = 0; i < _unreadMessages.length; i++)
          try {
            var data = {'id': _unreadMessages[i].toString()};
            // print('---data type------ ${data.runtimeType}');
            // print('-data------- $data');
            print(url);
            final response = await http.post(url, body: data);
            print(response);
            // final responseData = json.decode(response.body);
            // print('Read message -> api response: $responseData');
          } catch (error) {
            print('-------error of reading all messages $error');
          }
      }
    } catch (error) {
      print('readMessages error: $error');
    }
    await getApiData();
    await getApiFriends();
    await getApiFriendChat(friendId);
    notifyListeners();
  }

  Future<void> initFriends() async {
    await getApiData();
    await getApiFriends();
    return initPusher();
  }

  Future<void> initFriendChat(friendId) async {
    await getApiData();
    await getApiFriendChat(friendId);
    return initPusher2(friendId);
  }

  Future<void> addMessage(int id, int userId, String body, int statusId,
      String createdAt, bool my, String conferenceRoom) async {
    List _apiData = _apiMessagesData['friends'];
    final List<Message> loadedMessage = _friendChatList;
    final List<Friend> _newFriendList = _friendList;
    // List _extractedFriendList = [];
    for (var i = 0; i < _apiData.length; i++) {
      if (_apiData[i]['id'] == userId) {
        // _extractedFriendList = _apiData[i]['messages'];

        loadedMessage.add(
          Message(
            id: id.toString(),
            userId: userId.toString(),
            body: body,
            statusId: statusId.toString(),
            createdAt: createdAt,
            my: my,
            conferenceRoom: conferenceRoom ?? null,
          ),
        );
        // await new Future.delayed(const Duration(seconds: 5));
        // print(
        //     'first+++++++++++--------------------***********${loadedMessage.first.body}');
        // print(
        //     'last+++++++++++--------------------***********${loadedMessage.last.body}');
        // print(
        //     '0+++++++++++--------------------***********${loadedMessage[0].body}');
        // print(
        //     'last+++++++++++--------------------***********${loadedMessage[1].body}');

        // _friendList[i]['id']'messages'].last['body'] = '';
        _newFriendList[i].lastMessage = body;
        _newFriendList[i].unreadMessages += 1;
      }

      // for (var i = 0; i < _newFriendList.length; i++) {
      //   if (_newFriendList[i].id == userId.toString()) {
      //     _newFriendList[i].lastMessage = body;
      //     _newFriendList[i].unreadMessages += 1;
      //   }
      // }
    }

    _friendChatList = loadedMessage;
    _friendList = _newFriendList;
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
