import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/http_exception.dart';
import 'package:rozoom_app/providers/auth_provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/edit_profile_screen.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/widgets/tasks/task_item.dart';

class TaskOverviewScreen extends StatefulWidget {
  static const routeName = '/task-overview';

  @override
  _TaskOverviewScreenState createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await startTask();
      // var args =
      //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      // final int themeId = args['themeId'];
      // Provider.of<TaskModel>(context, listen: false)
      //     .startTask(themeId)
      // .then((_) {
      setState(() {
        _isLoading = false;
        // });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  startTask() async {
    try {
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final String themeName = args['themeName'];
      if (themeName == 'fix tasks') {
        await Provider.of<TaskModel>(context, listen: false).fixTasks();
        return;
      }
      final int themeId = args['themeId'];
      await Provider.of<TaskModel>(context, listen: false).startTask(themeId);
    } on HttpException catch (error) {
      var errorMessage = error.toString();
      Navigator.pop(context);
      _showErrorDialog(errorMessage);

      return;
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    // final task = Provider.of<Task>(context).taskItems;
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String themeName = args['themeName'];

    return Scaffold(
        // backgroundColor: Color(0XFFFEF9EB),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.grey,
              ),
              onPressed: () {
                _showExitDialog('');
              }),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.EditProfile) {
                    Navigator.of(context)
                        .pushNamed(EditProfileScreen.routeName);
                  } else {
                    // Provider.of<Auth>(context, listen: false).logout();
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: Text('Профайл'), value: FilterOptions.EditProfile),
                PopupMenuItem(
                    child: Text('Вийти'), value: FilterOptions.Logout),
              ],
            ),
          ],
          title: _isLoading
              ? Text('')
              : Consumer<Profile>(
                  builder: (ctx, profile, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(width: 35),
                      Image.asset('assets/images/stats/coin.png', scale: 0.55),
                      SizedBox(width: 5),
                      Text(profile.getBalance,
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(width: 10),
                      Image.asset('assets/images/stats/uah.png', height: 30),
                      SizedBox(width: 5),
                      Text(profile.getCertificates,
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ],
                  ),
                ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : TaskItem(themeName: themeName));
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
