import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
  String id = '';
  String userId = '';
  String body;
  String statusId = '';
  String createdAt = '';
  bool my;
  // String type;
  String conferenceRoom;
  // List<String> messages;

  Message({
    this.id,
    this.userId,
    this.body = '',
    this.statusId,
    this.createdAt,
    this.my,
    this.conferenceRoom,
  });
}
