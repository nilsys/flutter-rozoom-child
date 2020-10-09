import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';

class TaskResultScreen extends StatelessWidget {
  static const routeName = '/task-result';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'РЕЗУЛЬТАТ ЗАВДАННЯ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                          'assets/images/tasks/task-result-points-bg.png'),
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '6',
                          style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ))
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(
                                    Icons.check,
                                    color: Color(0xFF74bec9),
                                    size: 24,
                                  ),
                                  Text(
                                    ' Вірних відповідей: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    ' ${Provider.of<Tasks>(context).getRightCount}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: <Widget>[
                              //     Text(
                              //       '+1.5  ',
                              //       style: TextStyle(
                              //         fontSize: 20,
                              //         // fontWeight: FontWeight.bold,
                              //         color: Colors.green,
                              //       ),
                              //     ),
                              //     SvgPicture.asset(
                              //       'assets/images/coin.svg',
                              //       height: 30,
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(
                                    Icons.close,
                                    color: Color(0xFF74bec9),
                                    size: 24,
                                  ),
                                  Text(
                                    ' Помилок: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    ' ${Provider.of<Tasks>(context).getWrongCount}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: <Widget>[
                              //     Text(
                              //       ' -1.5  ',
                              //       style: TextStyle(
                              //         fontSize: 20,
                              //         // fontWeight: FontWeight.bold,
                              //         color: Colors.red,
                              //       ),
                              //     ),
                              //     SvgPicture.asset(
                              //       'assets/images/coin.svg',
                              //       height: 30,
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(
                                    Icons.attach_money,
                                    color: Color(0xFF74bec9),
                                    size: 24,
                                  ),
                                  Text(
                                    'Отримано: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    ' ${Provider.of<Tasks>(context).getReward} ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/coin.svg',
                                    height: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    '? ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF74bec9),
                                    ),
                                  ),
                                  Text(
                                    'Оцінка: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    ' 6',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: ButtonTheme(
                    minWidth: 350,
                    height: 55,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(50.0),
                    //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          DisciplinesOverviewScreen.routeName,
                        );
                        Provider.of<Tasks>(context, listen: false)
                            .nullTaskData();
                        Provider.of<Themes>(context, listen: false)
                            .nullThemeImages();
                      },
                      elevation: 3.0,
                      highlightColor: Color(0xFF74bec9),
                      highlightElevation: 5.0,
                      child: Text(
                        'Перейти к списку завдань',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Color(0xFF74bec9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
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
