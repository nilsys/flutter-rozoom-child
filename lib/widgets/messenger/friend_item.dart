import 'package:flutter/material.dart';
import 'package:rozoom_app/widgets/chat/chat.dart';

class FriendItem extends StatefulWidget {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String messageTime;
  int unreadMessages;
  bool onlineStatus;
  DateTime lastActivity;

  FriendItem(
    this.id,
    this.name,
    this.avatarUrl,
    this.lastMessage,
    this.unreadMessages,
    this.messageTime,
    this.onlineStatus,
    this.lastActivity,
  );

  @override
  _FriendItemState createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => Chat(widget.id, widget.name)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: widget.unreadMessages == 0 ? Colors.white : Color(0XFFFFEFFE),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                widget.onlineStatus
                    ? Container(
                        // color: Colors.grey[300],
                        width: 75,
                        height: 75,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Color(0xFF74bec9), width: 3)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(widget.avatarUrl),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 48,
                              left: 52,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 3)),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        // color: Colors.grey[300],
                        width: 75,
                        height: 75,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.grey, width: 3)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(widget.avatarUrl),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 48,
                              left: 52,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 3)),
                              ),
                            )
                          ],
                        ),
                      ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        widget.lastMessage,
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  widget.messageTime.split(' ').last.substring(0, 5),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                widget.unreadMessages == 0
                    ? SizedBox.shrink()
                    : Container(
                        width: 40.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.unreadMessages.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
      // child: ListBody(
      //   children: <Widget>[
      //     Divider(color: Colors.grey),
      //     Padding(
      //       padding: const EdgeInsets.only(bottom: 0),
      //       child: Row(
      //         children: <Widget>[
      //           Container(
      //             // color: Colors.grey[300],
      //             width: 75,
      //             height: 75,
      //             child: Stack(
      //               children: <Widget>[
      //                 Container(
      //                   decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       border:
      //                           Border.all(color: Color(0xFF74bec9), width: 3)),
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(3.0),
      //                     child: Container(
      //                       width: 75,
      //                       height: 75,
      //                       decoration: BoxDecoration(
      //                           shape: BoxShape.circle,
      //                           image: DecorationImage(
      //                               image: NetworkImage(widget.avatarUrl),
      //                               fit: BoxFit.cover)),
      //                     ),
      //                   ),
      //                 ),
      //                 Positioned(
      //                   top: 48,
      //                   left: 52,
      //                   child: Container(
      //                     width: 20,
      //                     height: 20,
      //                     decoration: BoxDecoration(
      //                         color: Colors.green,
      //                         shape: BoxShape.circle,
      //                         border:
      //                             Border.all(color: Colors.white, width: 3)),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //           SizedBox(
      //             width: 20,
      //           ),
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: <Widget>[
      //               Text(
      //                 widget.name,
      //                 style:
      //                     TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      //               ),
      //               SizedBox(
      //                 height: 5,
      //               ),
      //               SizedBox(
      //                 width: MediaQuery.of(context).size.width - 135,
      //                 child: Text(widget.lastMessage ?? ''),
      //               )
      //             ],
      //           ),
      //           Container(
      //             child: Text(
      //               widget.unreadMessages.toString(),
      //               style: TextStyle(fontWeight: FontWeight.bold),
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //     Divider(color: Colors.grey),
      //   ],
      // ),
    );
  }
}
