import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rozoom_app/core/models/api.dart';
import 'package:rozoom_app/core/providers/auth_provider.dart';
import 'package:rozoom_app/core/providers/friend_provider.dart';
import 'package:rozoom_app/core/providers/pusher_provider.dart';
import 'package:rozoom_app/ui/messenger_screens/widgets/chat/conference_alert.dart';

import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final String id;
  final String name;
  const Chat(this.id, this.name);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  _buildMessage(Message message, bool isMe) {
    return Container(
      margin: isMe
          ? EdgeInsets.only(bottom: 8.0, top: 8.0, left: 80.0)
          : EdgeInsets.only(bottom: 8.0, top: 8.0, right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.createdAt,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          message.body.startsWith('Заходи на конференцию')
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ConferenceAlert(message.conferenceRoom, '')));
                  },
                )
              : Text(
                  message.body ?? '',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
      // color: Color(0XFFFFEFEE),
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0XFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
    );
  }

  final _controller = TextEditingController();
  var _enteredMessage = '';
  List<Message> _friends = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      (Provider.of<Pusher>(context, listen: false).initFriendChat(widget.id))
          .catchError((onError) {
        print('error init2------------------------------------->$onError');
      });
      // Provider.of<Pusher>(context, listen: false).initFriendChat(widget.id);
    });
  }

  sendApi() async {
    FocusScope.of(context).unfocus();
    var data = {'to_id': widget.id, 'body': _enteredMessage};
    final _token = Provider.of<Auth>(context, listen: false).token;
    // var resRozoom = await CallApi()
    //     .postData(data, 'mobile/me?api_token=${_token.getTokenData}');
    // final _token = Provider.of<TokenData>(context, listen: false);
    // var _token = context.watch<ChatTokenData>().getTokenData;
    var resChat =
        await CallApi().postData(data, 'me/chat/send?api_token=$_token');
    // var _chatData = resChat.body;
    // print('************************chat data: $_chatData');
    // Map<String, dynamic> _data = json.decode(_chatData);
    // final _chatToken = _data['csrf'];
    // print('9999999999999999999999$_chatToken');
    // context.read<ChatTokenData>().changeTokenData(_chatToken);
    // context.read<UserData>().changeUserData(_chatData);
    _controller.clear();
    _enteredMessage = '';
    await Provider.of<Pusher>(context, listen: false).getApiData();
    await Provider.of<Pusher>(context, listen: false).getApiFriends();
    await Provider.of<Pusher>(context, listen: false)
        .getApiFriendChat((widget.id).toString());
    // Provider.of<Pusher>(context, listen: false)
    //   .getApiFriendChat((widget.id).toString());
  }

  @override
  Widget build(BuildContext context) {
    final friendsChatListData = Provider.of<Pusher>(context);
    final frindsChatList = friendsChatListData.friendChatList.reversed.toList();
    _friends = frindsChatList;
    // final countMessage = Provider.of<MessageCount>(context, listen: false);
    // countMessage.setToZeroMessageCount();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            await Provider.of<Pusher>(context, listen: false).initPusher();
            print('------------OK!!!!!!!!!!!!!!!!!-----------------');

            // print('ggggggggggggggggggggggg');

            return Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
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
                child: ListView(
                  reverse: true,
                  children: <Widget>[
                    // _newMessage(),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      // padding: EdgeInsets.all(15),
                      child: (ListBody(
                        reverse: true,
                        children: _buildList(),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _newMessage(),
          //
        ],
      ),
    );
  }

  // _navigateFriendChat(BuildContext context) async {
  //   print('1111111111111111111111');
  //   await Provider.of<Pusher>(context, listen: false).initFriends();
  //   print('2222222222222222222');
  //   await Navigator.pop(context, print('ggggggggggggggggggggggg'));
  //   print('333333333333333333');
  // }

  _buildList() {
    return _friends
        .map(
          (Message f) => Container(
            margin: f.my
                ? EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 80.0,
                  )
                : EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    right: 80.0,
                  ),
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: f.my ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
              borderRadius: f.my
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  f.createdAt,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.0),
                f.body.startsWith('Заходи на конференцию')
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ConferenceAlert(f.conferenceRoom, 'Я')));
                        },
                        child: Text(
                          'Заходи в видеочат!',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.pink,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        f.body ?? '',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ],
            ),
          ),
        )
        .toList();
  }

  _newMessage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration.collapsed(
                hintText: 'Введите сообщение',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          Consumer<MessageCount>(
            builder: (_, count, icon) => IconButton(
                color: Color(0XFFFFEFEE),
                icon: Icon(
                  Icons.send,
                ),
                onPressed: _enteredMessage.trim().isEmpty ? null : sendApi),
          ),
        ],
      ),
    );
  }
}
