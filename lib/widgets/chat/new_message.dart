import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/api.dart';
import 'package:rozoom_app/providers/auth_provider.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';

class NewMessage extends StatefulWidget {
  final String id;

  const NewMessage(this.id);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  sendApi() async {
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
    setState(() {});
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chats/ESQs42pzMBjGQ7gaz0hD/messages').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'name': userData['name'],
    });
    _controller.clear();
    _enteredMessage = '';
    // var _messageCount = context.watch<MessageCount>().getMessageCount;
    // print('_messageCount now: $_messageCount');

    context.read<MessageCount>().incrementMessageCount();

    // var _newMessageCount = context.watch<MessageCount>().getMessageCount;
    // print('_newMessageCount now: $_newMessageCount');
  }

  @override
  Widget build(BuildContext context) {
    // final countMessage = Provider.of<MessageCount>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: 'Введите сообщение',
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
                color: Colors.pink,
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
