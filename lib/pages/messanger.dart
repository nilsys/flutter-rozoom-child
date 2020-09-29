// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_pusher_client/flutter_pusher.dart';
// import 'package:laravel_echo/laravel_echo.dart';

// import 'package:rozoom_app/api/api.dart';
// import 'package:provider/provider.dart';
// import 'package:rozoom_app/models/Provider.dart';
// import 'package:rozoom_app/models/messenger/Messenger.dart';
// import 'package:rozoom_app/pages/chat.dart';
// import 'package:rozoom_app/pages/video_screen.dart';
// import 'package:rozoom_app/providers/pusher_provider.dart';
// import 'package:rozoom_app/providers/video_chat_provider.dart';

// class Messenger extends StatefulWidget {
//   @override
//   _MessengerState createState() => _MessengerState();
// }

// class _MessengerState extends State<Messenger> {
//   List<Friends> _friends = [];

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<Pusher>(context, listen: false).slowApi();
//     List<Friends> friendList =
//         Provider.of<Pusher>(context, listen: false).friendList;
//     _friends = friendList;

//     // userApi();
//   }

//   Future<void> userApi() async {
//     setState(() {});
//     try {
//       // await new Future.delayed(const Duration(seconds: 5));
//       // Provider.of<Pusher>(context, listen: false).getFriends();
//       List<Friends> friendList =
//           Provider.of<Pusher>(context, listen: false).friendList;
//       _friends = friendList;
//       print('ffffffffffffffffffffffffffffffffffff$_friends');
//     } catch (error) {
//       print('frienlist error-------------------------------: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String _videoChatName =
//         Provider.of<VideoChat>(context, listen: false).videoChatName;

//     Random random = new Random();
//     int rnd = random.nextInt(1000000);
//     print(rnd);
//     return Scaffold(
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: <Widget>[
//             Video(),
//             Container(
//               margin: EdgeInsets.only(top: 15),
//               padding: EdgeInsets.all(15),
//               child: (ListBody(
//                 children: _buildList(),
//               )),
//             ),
//             Divider(color: Colors.grey),
//             Container(
//               child: SizedBox(
//                 height: 40,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   _buildList() {
//     var lastMessageNoConsumer =
//         Provider.of<Pusher>(context, listen: false).getLastPusherMessage;
//     return _friends
//         .map(
//           (Friends f) => InkWell(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (_) => Chat(f.id, f.name)));
//             },
//             child: Column(
//               children: <Widget>[
//                 Divider(color: Colors.grey),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   child: Row(
//                     children: <Widget>[
//                       Container(
//                         width: 75,
//                         height: 75,
//                         child: Stack(
//                           children: <Widget>[
//                             Container(
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                       color: Color(0xFF74bec9), width: 3)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(3.0),
//                                 child: Container(
//                                   width: 75,
//                                   height: 75,
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       image: DecorationImage(
//                                           image: NetworkImage(f.avatarUrl),
//                                           fit: BoxFit.cover)),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: 48,
//                               left: 52,
//                               child: Container(
//                                 width: 20,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                         color: Colors.white, width: 3)),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             f.name,
//                             style: TextStyle(
//                                 fontSize: 17, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width - 135,
//                             child: Consumer<Pusher>(
//                               builder: (context, value, child) => Text(
//                                   value.getLastPusherMessage ?? 'no messages'),
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 // Divider(color: Colors.grey),
//               ],
//             ),
//           ),
//         )
//         .toList();
//   }
// }
