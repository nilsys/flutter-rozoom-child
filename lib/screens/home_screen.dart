import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/api/api.dart';
import 'package:rozoom_app/pages/conference_alert.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/screens/messenger/friends_overview_screen.dart';
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
        print('onMessage: $msg');
        showDialog(
          context: context,
          builder: (context) =>
              // ConferenceAlert('roomName', 'username'),
              AlertDialog(
            backgroundColor: Colors.blue,
            content: ListTile(
              title: Text('${msg['notification']['body']}',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text('${msg['data']['conference_room']}',
                  style: TextStyle(color: Colors.white)),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ConferenceAlert('000', '000'),
                //   ),
                // ),
                child: Text('Ок', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> msg) async {
        print('onLaunch: $msg');
        showDialog(
          context: context,
          builder: (context) =>
              // ConferenceAlert('roomName', 'username'),
              AlertDialog(
            backgroundColor: Colors.blue,
            content: ListTile(
              title: Text('${msg['notification']['body']}',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text('${msg['data']['conference_room']}',
                  style: TextStyle(color: Colors.white)),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ConferenceAlert('000', '000'),
                //   ),
                // ),
                child: Text('Ок', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      onResume: (Map<String, dynamic> msg) async {
        print('onResume: $msg');
        showDialog(
          context: context,
          builder: (context) =>
              // ConferenceAlert('roomName', msg['']),
              AlertDialog(
            backgroundColor: Colors.blue,
            content: ListTile(
              title: Text('${msg['notification']['body']}',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text('${msg['data']['conference_room']}',
                  style: TextStyle(color: Colors.white)),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ConferenceAlert('000', '000'),
                //   ),
                // ),
                child: Text('Ок', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
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
    print('oooooookkkkkkkkkkkk');
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
          FriendsOverviewScreen(),
          WebViewWebPage(),
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

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favorited $url')),
                );
              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
}

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.showUserAgent:
                _onShowUserAgent(controller.data, context);
                break;
              case MenuOptions.listCookies:
                _onListCookies(controller.data, context);
                break;
              case MenuOptions.clearCookies:
                _onClearCookies(context);
                break;
              case MenuOptions.addToCache:
                _onAddToCache(controller.data, context);
                break;
              case MenuOptions.listCache:
                _onListCache(controller.data, context);
                break;
              case MenuOptions.clearCache:
                _onClearCache(controller.data, context);
                break;
              case MenuOptions.navigationDelegate:
                print('navigation delegate ------------------------------->');
                _onNavigationDelegateExample(controller.data, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.showUserAgent,
              child: const Text('Show user agent'),
              enabled: controller.hasData,
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCookies,
              child: Text('List cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.addToCache,
              child: Text('Add to cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCache,
              child: Text('List cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCache,
              child: Text('Clear cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.navigationDelegate,
              child: Text('Navigation Delegate example'),
            ),
          ],
        );
      },
    );
  }

  void _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    controller.evaluateJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  void _onListCookies(
      WebViewController controller, BuildContext context) async {
    final String cookies =
        await controller.evaluateJavascript('document.cookie');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  void _onAddToCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript(
        'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text('Added a test entry to cache.'),
    ));
  }

  void _onListCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript('caches.keys()'
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await controller.clearCache();
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text("Cache cleared."),
    ));
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _onNavigationDelegateExample(
      WebViewController controller, BuildContext context) async {
    // final String contentBase64 =
    // base64Encode('const Utf8Encoder().convert(kNavigationExamplePage)');
    // controller.loadUrl('data:text/html;base64,$contentBase64');
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        controllerGlobal = controller;

        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No back history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        controller.goForward();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("No forward history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
