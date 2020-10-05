import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';

class TaskOverviewScreen extends StatefulWidget {
  static const routeName = '/task-overview';

  @override
  _TaskOverviewScreenState createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final int themeId = args['themeId'];

      Provider.of<Themes>(context, listen: false).fetchAndSetTask(themeId);
    });

    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Вийти із завдання?'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Так'),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(DisciplinesOverviewScreen.routeName);
              Provider.of<Themes>(context, listen: false).nullThemeImages();
            },
          ),
          FlatButton(
            child: Text('Ні'),
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
    // final themes = Provider.of<Themes>(context).themeItems;
    return Scaffold(
        // backgroundColor: Color(0XFFFEF9EB),
        // backgroundColor: Color(0Xf8f9fa),
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
              // Row(
              //   children: <Widget>[
              //     SvgPicture.asset(
              //       'assets/images/coin.svg',
              //       height: 30,
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     Text(
              //       '366.60',
              //       style: TextStyle(color: Colors.black, fontSize: 16),
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     SvgPicture.asset(
              //       'assets/images/uah.svg',
              //       height: 40,
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     Text(
              //       '111',
              //       style: TextStyle(color: Colors.black, fontSize: 16),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.check,
                            color: Color(0xFFf06388),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('1'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.close,
                            color: Color(0xFFf06388),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('0'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.attach_money,
                            color: Color(0xFFf06388),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('1.00'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFf06388),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('1/7'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              width: double.infinity,
              height: 330,
              child: Card(
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: ClipRRect(
                        // borderRadius: BorderRadius.all(
                        //   Radius.circular(30),
                        // ),
                        child: FadeInImage(
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.contain,
                          image: NetworkImage(
                              'https://rozoom.com.ua/uploads/tasks/V6jDH2eryfzZ09QWeNQXQIX15RhiTYPo7UCxjyNs.jpeg'),
                          // fadeInDuration: Duration(seconds: 3),

                          // fadeOutDuration: Duration(seconds: 1),
                          placeholder: AssetImage('assets/images/brand.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 20, left: 20),
                      child: Container(
                        // height: 30,
                        child: Center(
                          child: Text(
                            themeName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 150,
                    height: 40,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(50.0),
                    //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    child: RaisedButton(
                      onPressed: () {},
                      elevation: 3.0,
                      highlightColor: Color(0xFF74bec9),
                      highlightElevation: 5.0,
                      child: Text(
                        '1',
                        style: TextStyle(
                            color: Color(0xFF74bec9),
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.white,
                      // padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Color(0xFF74bec9), width: 1)),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 150,
                    height: 40,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(50.0),
                    //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    child: RaisedButton(
                      onPressed: () {},
                      elevation: 3.0,
                      highlightColor: Color(0xFF74bec9),
                      highlightElevation: 5.0,
                      child: Text(
                        '2',
                        style: TextStyle(
                            color: Color(0xFF74bec9),
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.white,
                      // padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Color(0xFF74bec9), width: 1)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 150,
                    height: 40,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(50.0),
                    //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    child: RaisedButton(
                      onPressed: () {},
                      elevation: 3.0,
                      highlightColor: Color(0xFF74bec9),
                      highlightElevation: 5.0,
                      child: Text(
                        '3',
                        style: TextStyle(
                            color: Color(0xFF74bec9),
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.white,
                      // padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Color(0xFF74bec9), width: 1)),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 150,
                    height: 40,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(50.0),
                    //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    child: RaisedButton(
                      onPressed: () {},
                      elevation: 3.0,
                      highlightColor: Color(0xFF74bec9),
                      highlightElevation: 5.0,
                      child: Text(
                        '4',
                        style: TextStyle(
                            color: Color(0xFF74bec9),
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.white,
                      // padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Color(0xFF74bec9), width: 1)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
