import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/achievements_provider.dart';
import 'package:rozoom_app/core/providers/auth_provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/core/providers/pusher_provider.dart';
import 'package:rozoom_app/core/providers/task_provider.dart';
import 'package:rozoom_app/core/providers/training_provider.dart';
import 'package:rozoom_app/core/providers/video_chat_provider.dart';
import 'package:rozoom_app/ui/achievments_screens/achievments_screen.dart';
import 'package:rozoom_app/ui/achievments_screens/cards_screen.dart';
import 'package:rozoom_app/ui/home_screens/index_screen.dart';
import 'package:rozoom_app/ui/profile_screen/edit_profile_screen.dart';
import 'package:rozoom_app/ui/auth_screen/authentication_screen.dart';
import 'package:rozoom_app/ui/tasks_screens/disciplines_overview_screen.dart';
import 'package:rozoom_app/ui/tasks_screens/fix_task_screen.dart';
import 'package:rozoom_app/ui/tasks_screens/task_overview_screen.dart';
import 'package:rozoom_app/ui/tasks_screens/task_result_screen.dart';
import 'package:rozoom_app/ui/tasks_screens/themes_overview_screen.dart';
import 'package:rozoom_app/ui/training_screens/training_process_screen.dart';
import 'package:rozoom_app/ui/training_screens/training_result_screen.dart';
import 'package:rozoom_app/ui/training_screens/trainings_overview_screen.dart';
import 'package:rozoom_app/ui/training_screens/training_preview_screen.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';

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
        ChangeNotifierProxyProvider<Auth, Achievments>(
          create: (BuildContext context) =>
              Achievments(Provider.of<Auth>(context, listen: false).token),
          update: (BuildContext context, auth, _) => Achievments(auth.token),
        ),
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
                ? IndexScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) {
                      return authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? MyLoaderScreen()
                          : AuthScreen();
                    },
                  ),
        theme: ThemeData(
            appBarTheme: AppBarTheme(color: Colors.white, elevation: 0),
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
          AchievmentsScreen.routeName: (ctx) => AchievmentsScreen(),
          CardsScreen.routeName: (ctx) => CardsScreen(),
        },
      ),
    );
  }
}
