import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/models/exceptions.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/core/providers/task_provider.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';
import 'package:rozoom_app/shared/widgets/loader_widget.dart';
import 'package:rozoom_app/ui/tasks_screens/disciplines_overview_screen.dart';
import 'package:rozoom_app/ui/tasks_screens/widgets/task_item.dart';

class TaskOverviewScreen extends StatefulWidget {
  static const routeName = '/task-overview';

  @override
  _TaskOverviewScreenState createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((_) {
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final String themeName = args['themeName'];
      print('themeName $themeName');
      if (themeName == 'fix tasks') {
        print('fix &&&&&&&&&');
        Provider.of<TaskModel>(context, listen: false).fixTasks();
        return;
      } else {
        final String themeId = args['themeId'];
        print('themeId $themeId');
        Provider.of<TaskModel>(context, listen: false).startTask(themeId);
      }
    }).then((_) => setState(() {
          _isLoading = false;
        }));
    super.initState();
  }

  startTask() {
    try {
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final String themeName = args['themeName'];
      print('themeName $themeName');
      if (themeName == 'fix tasks') {
        print('fix &&&&&&&&&');
        Provider.of<TaskModel>(context, listen: false).fixTasks();
        return;
      } else {
        final int themeId = args['themeId'];
        print('themeId $themeId');
        Provider.of<TaskModel>(context, listen: false).startTask(themeId);
      }
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      Navigator.pop(context);
      _showErrorDialog(errorMessage);

      return;
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    // final task = Provider.of<Task>(context).taskItems;
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String themeName = args['themeName'];

    return Consumer<TaskModel>(
      builder: (context, cards, child) => cards.isLoadingScreen
          ? MyLoaderScreen()
          : Scaffold(
              // backgroundColor: Color(0XFFFEF9EB),
              appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Provider.of<Themes>(context, listen: false)
                        .nullThemeImages();
                    Navigator.of(context).pop();
                  },
                ),
                actions: <Widget>[],
                title: Consumer<Profile>(
                  builder: (ctx, profile, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 35),
                      Image.asset('assets/images/stats/coin.png', scale: 0.55),
                      SizedBox(width: 5),
                      profile.isLoadingScreen
                          ? SizedBox(
                              child: myLoaderWidget(),
                              width: defaultSize * 5,
                            )
                          : Text(profile.profileItems['uom'].uom,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(width: 10),
                      Image.asset('assets/images/stats/uah.png', height: 30),
                      SizedBox(width: 5),
                      profile.isLoadingScreen
                          ? SizedBox(
                              child: myLoaderWidget(),
                              width: defaultSize * 5,
                            )
                          : Text(profile.profileItems['balance'].balance,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              body: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : TaskItem(themeName: themeName)),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          'Увага!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              // Navigator.of(context)
              //     .pushNamed(DisciplinesOverviewScreen.routeName);
              // Provider.of<Themes>(context, listen: false).nullThemeImages();
              // Provider.of<Task>(context, listen: false).nullTaskData();
            },
          ),
          // FlatButton(
          //   child: Text(
          //     'Ні',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onPressed: () {
          //     Navigator.of(ctx).pop();
          //   },
          // )
        ],
      ),
    );
  }

  void _showExitDialog(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          'Завершити проходження?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Так',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(DisciplinesOverviewScreen.routeName);
              Provider.of<Themes>(context, listen: false).nullThemeImages();
              // Provider.of<Task>(context, listen: false).nullTaskData();
            },
          ),
          FlatButton(
            child: Text(
              'Ні',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
