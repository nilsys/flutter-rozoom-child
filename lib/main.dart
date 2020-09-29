import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/Provider.dart';
import 'package:rozoom_app/screens/auth_screen.dart';
import 'package:rozoom_app/screens/authentication_screen.dart';
import 'package:rozoom_app/screens/home_screen.dart';
import 'package:rozoom_app/providers/auth_token_provider.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/providers/video_chat_provider.dart';
import 'package:rozoom_app/screens/home_test_screen.dart';
import 'package:rozoom_app/screens/webview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TokenData>(create: (context) => TokenData()),
        ChangeNotifierProvider<ChatTokenData>(
            create: (context) => ChatTokenData()),
        ChangeNotifierProvider<UserData>(create: (context) => UserData()),
        ChangeNotifierProvider<MessageCount>(
            create: (context) => MessageCount()),
        ChangeNotifierProvider<MyId>(create: (context) => MyId()),
        //new providers
        ChangeNotifierProvider.value(
          value: AuthToken(),
        ),
        ChangeNotifierProxyProvider<AuthToken, VideoChat>(
          create: (_) => VideoChat(),
          update: (_, auth, token) => token..setAuthToken = auth.getAuthToken,
        ),
        ChangeNotifierProxyProvider<AuthToken, Pusher>(
          create: (_) => Pusher(),
          update: (_, auth, token) => token..setAuthToken = auth.getAuthToken,
        ),
      ],
      child: MaterialApp(
        home: MainPage(),
        theme: ThemeData(
          // primaryColor: Color(0xFFf06388),
          // primaryColor: Colors.red,
          primaryColor: Color(0xFF74bec9),
          accentColor: Color(0XFFFEF9EB),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => HomeChild(),
          '/auth': (context) => Auth(),

          // '/messenger': (context) => Messenger(),
          // '/chat': (context) => Chat(),
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreen(),
    );
  }
}
