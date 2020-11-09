import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/pusher_provider.dart';

import 'package:rozoom_app/ui/messenger_screens/widgets/messenger/friend_item.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5));
    (Provider.of<Pusher>(context, listen: false).initFriends())
        .catchError((onError) {
      print('error init------------------------------------->$onError');
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsListData = Provider.of<Pusher>(context);
    final frindList = friendsListData.friendList;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: ListView.builder(
          itemCount: frindList.length,
          itemBuilder: (ctx, i) => FriendItem(
            frindList[i].id,
            frindList[i].name,
            frindList[i].avatarUrl,
            frindList[i].lastMessage,
            frindList[i].unreadMessages,
            frindList[i].messageTime,
            frindList[i].onlineStatus,
            frindList[i].lastActivity,
          ),
        ),
      ),
    );
  }
}
