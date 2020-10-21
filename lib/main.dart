import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/Provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/authentication_screen.dart';
import 'package:rozoom_app/screens/home_screen.dart';
import 'package:rozoom_app/providers/auth_token_provider.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/providers/video_chat_provider.dart';
import 'package:rozoom_app/screens/edit_profile_screen.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/profile_screen.dart';
import 'package:rozoom_app/screens/tasks/task_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/task_result_screen.dart';
import 'package:rozoom_app/screens/tasks/themes_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/themes_overview_screen2.dart';
import 'package:rozoom_app/screens/test_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //
        ChangeNotifierProvider<Disciplines>(create: (context) => Disciplines()),
        ChangeNotifierProvider<Themes>(create: (context) => Themes()),

        ChangeNotifierProvider<TaskModel>(create: (context) => TaskModel()),
        ChangeNotifierProvider<Profile>(create: (context) => Profile()),
        //
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
        title: 'Rozoom',
        home: HomeChild(),
        theme: ThemeData(
          // primaryColor: Color(0xFFf06388),
          // primaryColor: Colors.red,
          primaryColor: Color(0xFF74bec9),
          accentColor: Color(0xFFf06388),
          // accentColor: Color(0XFFFEF9EB),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('uk'), const Locale('ru')],
        routes: {
          DisciplinesOverviewScreen.routeName: (context) =>
              DisciplinesOverviewScreen(),
          ThemesOverviewScreen.routeName: (context) => ThemesOverviewScreen(),
          ThemesOverviewScreen2.routeName: (context) => ThemesOverviewScreen2(),
          TaskOverviewScreen.routeName: (context) => TaskOverviewScreen(),
          TaskResultScreen.routeName: (context) => TaskResultScreen(),
          EditProfileScreen.routeName: (context) => EditProfileScreen(),

          '/home': (context) => HomeChild(),
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
      body: BottomNavBar(),
    );
  }
}
