import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/auth_provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/providers/video_chat_provider.dart';
import 'package:rozoom_app/screens/edit_profile_screen.dart';
import 'package:rozoom_app/screens/splash_screen.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/fix_task_screen.dart';
import 'package:rozoom_app/screens/tasks/task_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/task_result_screen.dart';
import 'package:rozoom_app/screens/tasks/themes_overview_screen.dart';
import 'package:rozoom_app/screens/authentication_screen.dart';
import 'package:rozoom_app/screens/index_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Disciplines>(
          create: (_) => Disciplines(''),
          update: (ctx, auth, _) => Disciplines(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Themes>(
          create: (_) => Themes(''),
          update: (ctx, auth, _) => Themes(auth.token),
        ),
        ChangeNotifierProvider<ThemeModel>(create: (_) => ThemeModel()),
        ChangeNotifierProxyProvider<Auth, TaskModel>(
          create: (_) => TaskModel(''),
          update: (ctx, auth, _) => TaskModel(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Profile>(
          create: (_) => Profile(''),
          update: (ctx, auth, _) => Profile(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, VideoChat>(
          create: (_) => VideoChat(''),
          update: (ctx, auth, _) => VideoChat(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Pusher>(
          create: (_) => Pusher(''),
          update: (ctx, auth, _) => Pusher(auth.token),
        ),
        ChangeNotifierProvider<MessageCount>(
            create: (context) => MessageCount()),
        ChangeNotifierProvider<MyId>(create: (context) => MyId()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Rozoom',
          home: auth.isAuth
              ? IndexScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          theme: ThemeData(
            primaryColor: Color(0xFF74bec9),
            accentColor: Color(0xFFf06388),
            fontFamily: 'Robot Regular',
            // accentColor: Color(0XFFFEF9EB),
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [const Locale('uk'), const Locale('ru')],
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            IndexScreen.routeName: (context) => IndexScreen(),
            DisciplinesOverviewScreen.routeName: (context) =>
                DisciplinesOverviewScreen(),
            ThemesOverviewScreen.routeName: (context) => ThemesOverviewScreen(),
            TaskOverviewScreen.routeName: (context) => TaskOverviewScreen(),
            TaskResultScreen.routeName: (context) => TaskResultScreen(),
            FixTaskScreen.routeName: (context) => FixTaskScreen(),
            EditProfileScreen.routeName: (context) => EditProfileScreen(),
          },
        ),
      ),
    );
  }
}
