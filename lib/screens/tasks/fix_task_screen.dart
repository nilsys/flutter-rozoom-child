import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/task_overview_screen.dart';

class FixTaskScreen extends StatefulWidget {
  static const routeName = '/fix-task';

  @override
  _FixTaskScreenState createState() => _FixTaskScreenState();
}

class _FixTaskScreenState extends State<FixTaskScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<TaskModel>(context, listen: false).getFixTaskInfo();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'ВИПРАВЛЕННЯ ПОМИЛОК',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 15),
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/index/04.png'),
                          ],
                        ),
                      ),
                      Consumer<TaskModel>(
                        builder: (ctx, fix, child) => Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Завданнь для виправленя: ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '${fix.fixCount}',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: ButtonTheme(
                                minWidth: 250,
                                height: 55,
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        TaskOverviewScreen.routeName,
                                        arguments: {'themeName': 'fix tasks'});
                                  },
                                  elevation: 3.0,
                                  highlightColor: Theme.of(context).accentColor,
                                  highlightElevation: 5.0,
                                  child: Text(
                                    'Приступити до виправлення',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          width: 2,
                                          color:
                                              Theme.of(context).accentColor)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Вже виправлено ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${fix.fixedCount}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).accentColor),
                                  ),
                                  Text(
                                    ' завдань',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
