import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/api/api.dart';
import 'package:rozoom_app/pages/conference_alert.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/screens/index_screen.dart';
import 'package:rozoom_app/screens/messenger/friends_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/screens/webview_screen.dart';
import 'package:rozoom_app/widgets/chat/badge_icon.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rozoom_app/models/Provider.dart';

class HomeChild extends StatefulWidget {
  @override
  _HomeChildState createState() => _HomeChildState();
}

WebViewController controllerGlobal;

Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
    return Future.value(true);
  } else {
    print("no goback");
    Scaffold.of(context).showSnackBar(
      const SnackBar(content: Text("Не нада")),
    );
    return Future.value(false);
  }
}

class _HomeChildState extends State<HomeChild> {
  bool _isLoading = false;
  StreamController<int> _countController = StreamController<int>();
  int _tabBarCount = 0;
  int _selectedIndex = 1;

  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

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
        void _showErrorDialog(String message) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Приєднатися до нового відеочату?'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ні'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text('Так'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConferenceAlert(
                            msg['data']['conference_room'],
                            msg['data']['friend_name']),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        print('onMessage: $msg');
        _showErrorDialog('${msg['notification']['body']}');
      },
      onLaunch: (Map<String, dynamic> msg) async {
        void _showErrorDialog(String message) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Приєднатися до нового відеочату?'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ні'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text('Так'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConferenceAlert(
                            msg['data']['conference_room'],
                            msg['data']['friend_name']),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        print('onLaunch: $msg');
        _showErrorDialog('');
      },
      onResume: (Map<String, dynamic> msg) async {
        void _showErrorDialog(String message) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Приєднатися до нового відеочату?'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ні'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text('Так'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConferenceAlert(
                            msg['data']['conference_room'],
                            msg['data']['friend_name']),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        print('onResume: $msg');
        _showErrorDialog('');
      },
    );
  }

  // Future onSelectNotification(String payload) async {
  //   print('+++++++++++++++++++++++++++++++++++++$payload');
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => ConferenceAlert(payload)),
  //   );
  // }

  // NotificationDetails get _ongoing {
  //   final androidChannelSpecifics = AndroidNotificationDetails(
  //     'your channel id',
  //     'your channel name',
  //     'your channel description',
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //     ongoing: true,
  //     autoCancel: true,
  //     color: Colors.grey,
  //   );
  //   final iOSChannelSpecifics = IOSNotificationDetails();
  //   return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
  // }

  // Future showOngoingNotification(
  //   FlutterLocalNotificationsPlugin notifications, {
  //   @required String title,
  //   @required String body,
  //   String payload,
  //   int id = 0,
  // }) =>
  //     _showNotification(notifications,
  //         title: title, body: body, id: id, type: _ongoing, payload: payload);

  // Future _showNotification(
  //   FlutterLocalNotificationsPlugin notifications, {
  //   @required String title,
  //   @required String body,
  //   @required NotificationDetails type,
  //   int id = 0,
  //   String payload,
  // }) =>
  //     notifications.show(
  //       id,
  //       title,
  //       body,
  //       type,
  //       payload: title,
  //     );

  // Future onSelectNotification(String payload) async {
  //   context.read<TokenData>().changeTokenData('Token Data droped');
  //   final _token = context.watch<TokenData>().getTokenData;
  //   print('+++++++++++++++++++++++++++++++++++++$payload');
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => Right(_token)),
  //   );
  // }

  void handleRouting(dynamic routeValue) {
    // print('oooooookkkkkkkkkkkk');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            ConferenceAlert('roomName', 'username'),
      ),
    );
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int rnd = random.nextInt(10000) + 999;
    print(rnd);
    final _token = context.watch<TokenData>().getTokenData;
    final unreadMessages = Provider.of<Pusher>(context).getTotalUnreadMessages;

    // print('***Token from TokenData on home screen: $_token');
    // final _userData = context.watch<UserData>().getUserData;
    // print('***Data from UserData on home screen: $_userData');
    // Map<String, dynamic> data = json.decode(userdata);

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       icon: Icon(
      //         Icons.menu,
      //         color: Colors.grey,
      //       ),
      //       onPressed: null),
      //   title: Center(
      //       child: SvgPicture.asset(
      //     'assets/images/portfolio/brand.svg',
      //     height: 35,
      //   )),
      //   backgroundColor: Colors.white,
      //   brightness: Brightness.light,
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(
      //         Icons.exit_to_app,
      //         color: Colors.grey,
      //       ),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ],
      // ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          // FriendsOverviewScreen(),
          // FriendsOverviewScreen(),
          DisciplinesOverviewScreen(),
          DisciplinesOverviewScreen(),
          // IndexScreen(),

          // FriendsOverviewScreen(),
          // WebViewWebPage(),
          // Right(rnd.toString()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // type: BottomNavigationBarType.fixed,
        // currentIndex: currentIndex,
        selectedItemColor: Color(0xFF74bec9),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
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
