import 'dart:convert';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:rozoom_app/core/models/api.dart';
import 'package:rozoom_app/core/models/exceptions.dart';
import 'package:rozoom_app/shared/constants.dart';

class Friend {
  final String id;
  final String name;
  final String avatarUrl;
  String lastMessage;
  int unreadMessages = 0;
  String messageTime;
  bool onlineStatus;
  DateTime lastActivity;

  Friend(
      {@required this.id,
      @required this.name,
      @required this.avatarUrl,
      @required this.lastMessage,
      this.unreadMessages,
      @required this.messageTime,
      this.onlineStatus,
      this.lastActivity});
}

class Message {
  String id;
  String userId;
  String body;
  String statusId;
  String createdAt;
  bool my;
  String conferenceRoom;

  Message({
    this.id,
    this.userId,
    this.body,
    this.statusId,
    this.createdAt,
    this.my,
    this.conferenceRoom,
  });
}

class RssMessage {
  String time;
  String user;
  String money;
  String body;

  RssMessage({this.time, this.user, this.money, this.body});
}

class Friends with ChangeNotifier {
  String authToken;
  String pusherToken;
  String totalUnreadMessages;
  Friends(this.authToken, this._friendList, this._rssMessageList,
      this._friendChatList);

  List data;

  List<Friend> _friendList = [];
  List<Friend> get friendList {
    return [..._friendList];
  }

  List<Message> _friendChatList = [];
  List<Message> get friendChatList {
    return [..._friendChatList];
  }

  List<RssMessage> _rssMessageList = [];
  List<RssMessage> get rssMessageList {
    return [..._rssMessageList];
  }

  bool _isLoadingScreen = false;
  bool get isLoadingScreen => _isLoadingScreen;
  bool _isLoadingWidget = false;
  bool get isLoadingWidget => _isLoadingWidget;

  Map<String, String> get headers =>
      {'Accept': 'text/json', 'Authorization': 'Bearer $authToken'};

  Future<void> apiGetFriendsInfo({String friendId}) async {
    const urlSegment = '/api/me/chat';
    final url = rozoomBaseUrl + urlSegment;

    _isLoadingScreen = true;
    print('_isLoadingScreen friends api = true');
    final response = await http.post(url, headers: headers);
    final extractedData = json.decode(response.body);
    // print('friends info --------> $extractedData');
    if (extractedData['error'] != null) {
      throw TokenException();
    }
    data = extractedData['friends'];
    parseFriendsList(extractedData['friends']);
    pusherToken = extractedData['csrf'];
    totalUnreadMessages = extractedData['unread'].toString();
    if (friendId != null) {
      parseFriendChat(extractedData['friends'], friendId);
    }
    _isLoadingScreen = false;
    print('_isLoadingScreen friends api = false');
    notifyListeners();
  }

  void parseFriendsList(List data) {
    final List<Friend> loadedFriends = [];
    for (var i = 0; i < data.length; i++) {
      int unreadMessagesCount = 0;
      for (var k = 0; k < (data[i]['messages']).length; k++) {
        if (data[i]['messages'][k]['status_id'] == 2) {
          if (data[i]['messages'][k]['my'] == false) {
            unreadMessagesCount += 1;
          }
        }
      }
      loadedFriends.add(
        Friend(
          id: data[i]['id'].toString(),
          name: data[i]['name'],
          avatarUrl: data[i]['avatar_url'],
          lastMessage: data[i]['messages'].last['body'],
          messageTime: data[i]['messages'].last['created_at'].toString(),
          unreadMessages: unreadMessagesCount,
          lastActivity: (data[i]['last_activity'] != null)
              ? DateTime.parse(data[i]['last_activity'])
              : DateTime.parse("1982-01-18 15:15:15"),
          onlineStatus: (data[i]['last_activity'] != null &&
                  DateTime.now()
                          .difference(DateTime.parse(data[i]['last_activity']))
                          .inSeconds <
                      600)
              ? true
              : false,
        ),
      );
    }
    _friendList = loadedFriends;
  }

  void parseFriendChat(List data, String friendId) {
    //read messages

    //parse chat
    final List<Message> loadedFriendChat = [];
    Map _extractedFriendMap =
        data.firstWhere((element) => element['id'].toString() == friendId);
    List _extractedFriendList = _extractedFriendMap['messages'];

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
    notifyListeners();
  }

  Future<void> initPusher(myId) async {
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
      print('init pusher event -----> $event');
      await apiGetFriendsInfo(friendId: event['user_id'].toString());
    });

    echo.channel('public').listen('.payment', (event) async {
      print('rss event -----> $event');
      print(event['body']['ua']);
      print(event['body']['ua'].runtimeType);

      _rssMessageList.add(
        RssMessage(
            time: event['time'],
            user: removeAllHtmlTags(event['user']),
            money: removeAllHtmlTags(event['money']),
            body: removeAllHtmlTags(event['body']['ua'])
                .replaceAll('&quot;', '"')),
      );
      print(_rssMessageList);
      notifyListeners();
    });
  }

  Future<void> sendMessage(id, message) async {
    var data = {'to_id': id, 'body': message};

    const urlSegment = '/api/me/chat/send';
    final url = rozoomBaseUrl + urlSegment;

    _isLoadingWidget = true;
    print('_isLoadingWidget = true');
    final response = await http.post(url, body: data, headers: headers);
    final extractedData = json.decode(response.body);
    print('send message info --------> $extractedData');
    if (extractedData['error'] != null) {
      throw TokenException();
    }
    await apiGetFriendsInfo(friendId: id.toString());
    _isLoadingScreen = false;
    print('_isLoadingWidget = false');
    notifyListeners();
  }

  Future<void> readAllMessages(String friendId) async {
    const urlSegment = '/api/me/chat/read';
    final url = rozoomBaseUrl + urlSegment;

    List _unreadMessages = [];
    for (var i = 0; i < data.length; i++) {
      if ((data[i]['id']).toString() == friendId) {
        _unreadMessages = data[i]['unread'];
      }
    }
    if (_unreadMessages != null) {
      for (var i = 0; i < _unreadMessages.length; i++)
        try {
          var data = {'id': _unreadMessages[i].toString()};
          final response = await http.post(url, body: data, headers: headers);
          print(
              'Стираю !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        } catch (error) {
          print('-------error of reading all messages $error');
        }
    }
    // await apiGetFriendsInfo();

    notifyListeners();
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
