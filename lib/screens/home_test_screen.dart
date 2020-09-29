import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rozoom_app/api/api.dart';
import 'package:rozoom_app/pages/chat.dart';
import 'package:rozoom_app/pages/conference_alert.dart';
import 'package:rozoom_app/pages/messanger.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/screens/messenger/friends_overview_screen.dart';
import 'package:rozoom_app/widgets/chat/badge.dart';
import 'package:rozoom_app/widgets/chat/badge_icon.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rozoom_app/pages/video_screen.dart';
import 'package:rozoom_app/models/Provider.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  StreamController<int> _countController = StreamController<int>();
  int _tabBarCount = 0;
  int _selectedIndex = 1;

  bool _isLoading;

  final _key = UniqueKey();

  num _stackToView = 0;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 1;
    });
  }

  // final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });

    // _tabBarCount = context.watch<MessageCount>().getMessageCount;
    // _countController.sink.add(_tabBarCount);

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    // final settingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: (id, title, body, payload) =>
    //         onSelectNotification(title));

    // notifications.initialize(
    //     InitializationSettings(settingsAndroid, settingsIOS),
    //     onSelectNotification: onSelectNotification);

    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.onTokenRefresh.listen((fcmToken) async {
      final rozoomToken =
          Provider.of<Pusher>(context, listen: false).getRozoomToken;
      var data = {'token': fcmToken};
      print('---------------------------------------> $rozoomToken');
      print('---------------------------------------> $fcmToken');
      var res = await CallApi()
          .postData(data, 'me/add-push-token?api_token=$rozoomToken');
      var response = res.body;
      print('response-------------------> $response');
    });
    fbm.getToken();
    fbm.subscribeToTopic('conf');
    fbm.configure(
      onMessage: (Map<String, dynamic> msg) async {
        print('onMessage: $msg');
        showDialog(
            context: context,
            builder: (context) => ConferenceAlert('roomName', 'username')
            // AlertDialog(
            //   backgroundColor: Colors.blue,
            //   content: ListTile(
            //     title: Text('${msg['notification']['title']}',
            //         style: TextStyle(color: Colors.white)),
            //     subtitle: Text('${msg.toString()}',
            //         style: TextStyle(color: Colors.white)),
            //   ),
            //   actions: <Widget>[
            //     FlatButton(
            //       onPressed: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => ConferenceAlert('000'),
            //         ),
            //       ),
            //       child: Text('Ок', style: TextStyle(color: Colors.white)),
            //     ),
            //   ],
            // ),
            );
      },
      onLaunch: (Map<String, dynamic> msg) async {
        print('onLaunch: $msg');
        showDialog(
            context: context,
            builder: (context) => ConferenceAlert('roomName', 'username'));
      },
      onResume: (Map<String, dynamic> msg) async {
        print('onResume: $msg');
        showDialog(
            context: context,
            builder: (context) => ConferenceAlert('roomName', 'username'));
      },
    );
  }

  void handleRouting(dynamic routeValue) {
    print('oooooookkkkkkkkkkkk');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            ConferenceAlert('roomName', 'username'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int rnd = random.nextInt(10000) + 999;
    print(rnd);
    final _token = context.watch<TokenData>().getTokenData;
    final unreadMessages = Provider.of<Pusher>(context).getTotalUnreadMessages;

    return Scaffold(
      body: IndexedStack(
        index: _stackToView,
        children: <Widget>[
          _isLoading
              ? Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[300]),
                    backgroundColor: Colors.pink[200],
                    strokeWidth: 10,
                  ),
                )
              : FriendsOverviewScreen(),
          SafeArea(
            child: WebView(
              initialUrl:
                  ('https://rozoom.co.ua/redirect/dashboard?api_token=$_token'),
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: _handleLoad,
            ),
          ),

          // Right(rnd.toString()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // type: BottomNavigationBarType.fixed,
        // currentIndex: currentIndex,
        selectedItemColor: Color(0xFF74bec9),
        unselectedItemColor: Colors.grey,
        currentIndex: _stackToView,
        onTap: (index) {
          setState(() {
            _stackToView = index;
            // if (index == 0) {
            //   countMessage.setToZeroMessageCount();
            //   print(countMessage.getMessageCount);
            // }
          });
        },
        items: [
          BottomNavigationBarItem(
            // icon: Icon(Icons.people_outline, size: 25),
            icon: Consumer<Pusher>(
              builder: (_, count, icon) => BadgeIcon(
                  icon: Icon(Icons.people_outline, size: 25),
                  badgeCount: count.getTotalUnreadMessages),
            ),
            title: Text('Друзі'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('Навчання')),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.phone), title: Text('Созвон')),
        ],
      ),
    );
  }
}
