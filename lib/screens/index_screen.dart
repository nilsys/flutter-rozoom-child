import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/api/api.dart';
import 'package:rozoom_app/pages/conference_alert.dart';
import 'package:rozoom_app/providers/auth_provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/screens/edit_profile_screen.dart';
import 'package:rozoom_app/screens/home_child_screen.dart';
import 'package:rozoom_app/screens/messenger/friends_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/widgets/chat/badge_icon.dart';
import 'package:rozoom_app/models/Provider.dart';

enum FilterOptions {
  EditProfile,
  Logout,
}

class IndexScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  bool _isLoading = false;
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int rnd = random.nextInt(10000) + 999;
    print(rnd);
    final _token = context.watch<TokenData>().getTokenData;
    final unreadMessages = Provider.of<Pusher>(context).getTotalUnreadMessages;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(IndexScreen.routeName);
          },
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.EditProfile) {
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                  // _showOnlyFavorites = true;
                } else {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(AuthScreen.routeName);
                  Provider.of<Auth>(context, listen: false).logout();
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Профайл'),
                value: FilterOptions.EditProfile,
              ),
              PopupMenuItem(
                child: Text('Вийти'),
                value: FilterOptions.Logout,
              ),
            ],
          ),
        ],
        title: _isLoading
            ? Text('')
            : Consumer<Profile>(
                builder: (ctx, profile, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Text(
                    //   'Дісципліни',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    SizedBox(
                      width: 35,
                    ),
                    Image.asset(
                      'assets/images/stats/coin.png',
                      // height: 300,
                      scale: 0.55,
                      // width: 50,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      profile.getBalance,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/stats/uah.png',
                      height: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      profile.getCertificates,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          FriendsOverviewScreen(),
          DisciplinesOverviewScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // type: BottomNavigationBarType.fixed,
        // currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
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
        ],
      ),
    );
  }

  // final notifications = FlutterLocalNotificationsPlugin();

  // @override
  // void initState() {
  //   super.initState();

  //   final settingsAndroid = AndroidInitializationSettings('app_icon');

  //   final fbm = FirebaseMessaging();
  //   fbm.requestNotificationPermissions();
  //   fbm.onTokenRefresh.listen((fcmToken) async {
  //     final rozoomToken =
  //         Provider.of<Pusher>(context, listen: false).getRozoomToken;
  //     var data = {'token': fcmToken};
  //     print('---------------------------------------> $rozoomToken');
  //     print('---------------------------------------> $fcmToken');
  //     var res = await CallApi()
  //         .postData(data, 'me/add-push-token?api_token=$rozoomToken');
  //     var response = res.body;
  //     print('response-------------------> $response');
  //   });

  //   fbm.getToken();
  //   fbm.subscribeToTopic('conf');
  //   fbm.configure(
  //     onMessage: (Map<String, dynamic> msg) async {
  //       void _showErrorDialog(String message) {
  //         showDialog(
  //           context: context,
  //           builder: (ctx) => AlertDialog(
  //             title: Text('Приєднатися до нового відеочату?'),
  //             content: Text(message),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: Text('Ні'),
  //                 onPressed: () {
  //                   Navigator.of(ctx).pop();
  //                 },
  //               ),
  //               FlatButton(
  //                 child: Text('Так'),
  //                 onPressed: () {
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => ConferenceAlert(
  //                           msg['data']['conference_room'],
  //                           msg['data']['friend_name']),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       }

  //       print('onMessage: $msg');
  //       _showErrorDialog('${msg['notification']['body']}');
  //     },
  //     onLaunch: (Map<String, dynamic> msg) async {
  //       void _showErrorDialog(String message) {
  //         showDialog(
  //           context: context,
  //           builder: (ctx) => AlertDialog(
  //             title: Text('Приєднатися до нового відеочату?'),
  //             content: Text(message),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: Text('Ні'),
  //                 onPressed: () {
  //                   Navigator.of(ctx).pop();
  //                 },
  //               ),
  //               FlatButton(
  //                 child: Text('Так'),
  //                 onPressed: () {
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => ConferenceAlert(
  //                           msg['data']['conference_room'],
  //                           msg['data']['friend_name']),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       }

  //       print('onLaunch: $msg');
  //       _showErrorDialog('');
  //     },
  //     onResume: (Map<String, dynamic> msg) async {
  //       void _showErrorDialog(String message) {
  //         showDialog(
  //           context: context,
  //           builder: (ctx) => AlertDialog(
  //             title: Text('Приєднатися до нового відеочату?'),
  //             content: Text(message),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: Text('Ні'),
  //                 onPressed: () {
  //                   Navigator.of(ctx).pop();
  //                 },
  //               ),
  //               FlatButton(
  //                 child: Text('Так'),
  //                 onPressed: () {
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => ConferenceAlert(
  //                           msg['data']['conference_room'],
  //                           msg['data']['friend_name']),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       }

  //       print('onResume: $msg');
  //       _showErrorDialog('');
  //     },
  //   );
  // }

  // void handleRouting(dynamic routeValue) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (BuildContext context) =>
  //           ConferenceAlert('roomName', 'username'),
  //     ),
  //   );
  // }
}
