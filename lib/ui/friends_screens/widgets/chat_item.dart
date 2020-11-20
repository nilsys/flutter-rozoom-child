import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/friends_provider.dart';
import 'package:intl/intl.dart';
import 'package:rozoom_app/shared/size_config.dart';

class ChatItem extends StatefulWidget {
  final String avatarUrl;
  ChatItem({this.avatarUrl});

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    final chat = Provider.of<Friends>(context).friendChatList.reversed.toList();
    return Container(
      padding: EdgeInsets.only(bottom: defaultSize * 9),
      child: ListView.builder(
        reverse: true,
        itemCount: chat.length,
        itemBuilder: (context, i) => Container(
          margin: chat[i].my
              ? EdgeInsets.only(
                  top: defaultSize * 0.8,
                  bottom: defaultSize * 0.8,
                  left: defaultSize * 10,
                )
              : EdgeInsets.only(
                  top: defaultSize * 0.8,
                  bottom: defaultSize * 0.8,
                  right: defaultSize * 10,
                ),
          padding: EdgeInsets.symmetric(
              horizontal: defaultSize * 2.5, vertical: defaultSize * 1.5),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: chat[i].my ? Color(0xFFF391A0) : Color(0xFFFFEFEE),
            borderRadius: chat[i].my
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                checkDate(chat[i].createdAt),
                style: TextStyle(
                  color:
                      chat[i].my ? Colors.white.withOpacity(0.7) : Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              chat[i].body.startsWith('Заходи на конференцию')
                  ? InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) =>
                        //             ConferenceAlert(f.conferenceRoom, 'Я')));
                      },
                      child: Text(
                        'Заходи в видеочат!',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Text(
                      chat[i].body ?? '',
                      style: TextStyle(
                        color: chat[i].my ? Colors.white : Colors.black54,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  checkDate(date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final chDate = DateTime.parse(date);
    final aDate = DateTime(chDate.year, chDate.month, chDate.day);
    if (aDate == today) {
      return DateFormat.Hm('uk').format(chDate);
    } else if (aDate == yesterday) {
      return 'Вчора';
    } else {
      return DateFormat.yMMMd('uk').format(chDate);
    }
  }
}
