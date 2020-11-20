import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/models/exceptions.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/shared/widgets/dialogs.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';
import 'package:rozoom_app/ui/home_screens/home_screen.dart';
import 'package:rozoom_app/shared/widgets/app_drawer.dart';
import 'package:rozoom_app/ui/friends_screens/friends_overview_screen.dart';

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
  int _currentIndex = 1;

  @override
  void initState() {
    _getProfile(context);
    super.initState();
  }

  Future<void> _getProfile(context) async {
    try {
      await Provider.of<Profile>(context, listen: false).apiGetProfileInfo();
    } on TokenException catch (error) {
      print('Token Error');
      MyDialogs().showTokenErrorDialog(context);
    } on HttpException catch (error) {
      print(error);
      MyDialogs().showApiErrorDialog(context, error.toString());
    } catch (error) {
      MyDialogs().showUnknownErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Profile>(
      builder: (context, profile, child) => profile.isLoadingScreen
          ? MyLoaderScreen()
          : Scaffold(
              drawer: AppDrawer(),
              body: IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  FriendsOverviewScreen(id: profile.profileItems['id'].id),
                  MyHome(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                // type: BottomNavigationBarType.shifting,
                selectedItemColor: Theme.of(context).accentColor,
                unselectedItemColor: Theme.of(context).primaryColor,
                currentIndex: _currentIndex,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    // icon: Icon(Icons.people_outline, size: 25),
                    // icon: Consumer<Pusher>(
                    // builder: (_, count, icon) => BadgeIcon(
                    //       icon: Icon(Icons.people_outline, size: 25),
                    //       badgeCount: count.getTotalUnreadMessages),
                    // ),
                    icon: Icon(Icons.people_outline, size: 25),
                    label: 'Друзі',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.school),
                    label: 'Навчання',
                  ),
                ],
              ),
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
