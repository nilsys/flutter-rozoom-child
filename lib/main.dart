import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/auth_provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/providers/training_provider.dart';
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
import 'package:rozoom_app/screens/trainings/training_process_screen.dart';
import 'package:rozoom_app/screens/trainings/training_result_screen.dart';
import 'package:rozoom_app/screens/trainings/trainings_overview_screen.dart';
import 'package:rozoom_app/screens/trainings/training_preview_screen.dart';
import 'package:rozoom_app/size_config.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Disciplines>(
          create: (BuildContext context) =>
              Disciplines(Provider.of<Auth>(context, listen: false).token, []),
          update: (BuildContext context, auth, previous) => Disciplines(
              auth.token, previous == null ? [] : previous.disciplineItems),
        ),
        ChangeNotifierProxyProvider<Auth, Themes>(
          create: (BuildContext context) =>
              Themes(Provider.of<Auth>(context, listen: false).token, []),
          update: (BuildContext context, auth, previous) =>
              Themes(auth.token, previous == null ? [] : previous.themeItems),
        ),
        ChangeNotifierProvider<ThemeModel>(create: (_) => ThemeModel()),
        ChangeNotifierProxyProvider<Auth, TaskModel>(
          create: (BuildContext context) =>
              TaskModel(Provider.of<Auth>(context, listen: false).token),
          update: (BuildContext context, auth, _) => TaskModel(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Profile>(
          create: (BuildContext context) =>
              Profile(Provider.of<Auth>(context, listen: false).token),
          update: (BuildContext context, auth, _) => Profile(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, VideoChat>(
          create: (BuildContext context) =>
              VideoChat(Provider.of<Auth>(context, listen: false).token),
          update: (BuildContext context, auth, _) => VideoChat(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Pusher>(
          create: (BuildContext context) =>
              Pusher(Provider.of<Auth>(context, listen: false).token),
          update: (BuildContext context, auth, _) => Pusher(auth.token),
        ),
        ChangeNotifierProvider<MessageCount>(
            create: (context) => MessageCount()),
        ChangeNotifierProvider<MyId>(create: (context) => MyId()),
        //
        ChangeNotifierProxyProvider<Auth, TrainingThemes>(
          create: (BuildContext context) => TrainingThemes(
              Provider.of<Auth>(context, listen: false).token, []),
          update: (BuildContext context, auth, previous) => TrainingThemes(
              auth.token, previous == null ? [] : previous.trainingThemesItems),
        ),
        ChangeNotifierProxyProvider<Auth, Training>(
          create: (BuildContext context) =>
              Training(Provider.of<Auth>(context, listen: false).token, {}),
          update: (BuildContext context, auth, previous) => Training(
              auth.token, previous == null ? {} : previous.trainingItems),
        ),
        ChangeNotifierProvider<TrainingModel>(create: (_) => TrainingModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        title: 'Rozoom',
        home:
            // TrainingsOverviewScreen(),

            auth.isAuth
                ? TrainingsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) {
                      return authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen();
                    },
                  ),
        theme: ThemeData(
            appBarTheme: AppBarTheme(color: Colors.transparent, elevation: 0),
            primaryColor: Color(0xFF74bec9),
            accentColor: Color(0xFFf06388),
            fontFamily: 'Robot Regular',
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('uk'), const Locale('ru')],
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          IndexScreen.routeName: (ctx) => IndexScreen(),
          DisciplinesOverviewScreen.routeName: (ctx) =>
              DisciplinesOverviewScreen(),
          ThemesOverviewScreen.routeName: (ctx) => ThemesOverviewScreen(),
          TaskOverviewScreen.routeName: (ctx) => TaskOverviewScreen(),
          TaskResultScreen.routeName: (ctx) => TaskResultScreen(),
          FixTaskScreen.routeName: (ctx) => FixTaskScreen(),
          EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
          TrainingsOverviewScreen.routeName: (ctx) => TrainingsOverviewScreen(),
          TrainingPreviewScreen.routeName: (ctx) => TrainingPreviewScreen(),
          TrainingProcessScreen.routeName: (ctx) => TrainingProcessScreen(),
          TrainingResultScreen.routeName: (ctx) => TrainingResultScreen(),
        },
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  // Wrapper Widget
  @override
  Widget build(BuildContext context) {
    // print(screenHeight);
    Future.delayed(Duration.zero, () => showAlert(context));
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text("Hello world"),
        ),
      ),
    );
  }

  void showAlert(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop(true);
    });
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.green[50],
              child: Container(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  child: Icon(
                Icons.check,
                color: Colors.greenAccent,
                size: 250,
              )),
            ));
  }
}
