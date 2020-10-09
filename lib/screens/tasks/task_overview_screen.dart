import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/widgets/tasks/task_item.dart';

class TaskOverviewScreen extends StatefulWidget {
  static const routeName = '/task-overview';

  @override
  _TaskOverviewScreenState createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 1)).then((_) {
    //   var args =
    //       ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    //   final int themeId = args['themeId'];
    //   print(themeId);

    //   Provider.of<Tasks>(context, listen: false).startTask(themeId);
    // });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final int themeId = args['themeId'];
      print(themeId);

      Provider.of<Tasks>(context, listen: false).startTask(themeId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          'Вийти із завдання?',
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
              Provider.of<Tasks>(context, listen: false).nullTaskData();
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

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String themeName = args['themeName'];
    // final int themeId = args['themeId'];
    // Provider.of<Tasks>(context, listen: false).startTask(themeId);
    // final themes = Provider.of<Themes>(context).themeItems;
    return Scaffold(
        backgroundColor: Color(0XFFFEF9EB),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.grey,
              ),
              onPressed: () {
                _showErrorDialog('Результат буде втрачено!');
              }),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              onPressed: () {
                // Navigator.pop(context);
              },
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                themeName.length > 30
                    ? '${themeName.replaceRange(30, themeName.length, '...')}'
                    : '$themeName',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        body: TaskItem(themeName: themeName));
  }
}
