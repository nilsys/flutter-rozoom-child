import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/auth_provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/screens/edit_profile_screen.dart';
import 'package:rozoom_app/widgets/app_drawer.dart';
import 'package:rozoom_app/widgets/home_child.dart';

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
  int _currentIndex = 1;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Profile>(context, listen: false).getProfileInfo().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final balance = Provider.of<Profile>(context, listen: false).balance;
    final certificates =
        Provider.of<Profile>(context, listen: false).certificates;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.grey,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pushReplacementNamed(IndexScreen.routeName);
        //   },
        // ),
        actions: <Widget>[
          PopupMenuButton(
            padding: EdgeInsets.all(8),
            elevation: 1,
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.EditProfile) {
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                  // _showOnlyFavorites = true;
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logout();
                }
              });
            },
            icon: Icon(Icons.more_vert, color: Colors.grey),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Профайл'), value: FilterOptions.EditProfile),
              PopupMenuItem(child: Text('Вийти'), value: FilterOptions.Logout),
            ],
          ),
        ],
        title: _isLoading
            ? Text('')
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width: 35),
                  Image.asset('assets/images/stats/coin.png', scale: 0.55),
                  SizedBox(width: 5),
                  balance != null
                      ? Text(balance,
                          style: TextStyle(color: Colors.black, fontSize: 16))
                      : Text(''),
                  SizedBox(width: 10),
                  Image.asset('assets/images/stats/uah.png', height: 30),
                  SizedBox(width: 5),
                  certificates != null
                      ? Text(certificates,
                          style: TextStyle(color: Colors.black, fontSize: 16))
                      : Text(''),
                ],
              ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Text('chat screen'),
          HomeChild(),
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
            //   builder: (_, count, icon) => BadgeIcon(
            //       icon: Icon(Icons.people_outline, size: 25),
            //       badgeCount: count.getTotalUnreadMessages),
            // ),
            icon: Icon(Icons.people_outline, size: 25),
            title: Text('Друзі'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Навчання'),
          ),
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
