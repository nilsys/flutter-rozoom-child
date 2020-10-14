import 'package:flutter/material.dart';
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

  // @override
  // void initState() {
  //   Future.delayed(Duration(seconds: 1)).then((_) {
  //     var args =
  //         ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  //     final int themeId = args['themeId'];
  //     print('init state provider------------------------');

  //     Provider.of<Task>(context, listen: false).startTask(themeId);
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    print('did depencies start');
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final int themeId = args['themeId'];
      Provider.of<Task>(context, listen: false).startTask(themeId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    print('did depencies end');
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
              Provider.of<Task>(context, listen: false).nullTaskData();
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
    // final task = Provider.of<Task>(context).taskItems;
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String themeName = args['themeName'];

    // print(task[0].answerIdForApi);
    // print(task[0].answerType);
    // print(task[0].answerVariants);
    // print(task[0].continueOrFinish);
    // print(task[0].currentQuestionNumber);
    // print(task[0].imageUrl);
    // print(task[0].question);
    // print(task[0].resultPoints);
    // print(task[0].rewardAmount);
    // print(task[0].rightAnswerListElementNumber);
    // print(task[0].rightAnswerStringValue);
    // print(task[0].rightAnswersCount);
    // print(task[0].totalQuestionCount);
    // print(task[0].wrongAnswersCount);

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
