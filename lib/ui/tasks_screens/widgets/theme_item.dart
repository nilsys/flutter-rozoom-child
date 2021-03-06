import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/ui/tasks_screens/task_overview_screen.dart';

class ThemeItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String klass;
  final String tasksCount;
  ThemeItem(this.id, this.name, this.imageUrl, this.klass, this.tasksCount);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      margin: EdgeInsets.all(1),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: FadeInImage(
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                      // fadeInDuration: Duration(seconds: 3),

                      // fadeOutDuration: Duration(seconds: 1),
                      placeholder: AssetImage('assets/images/brand.png')),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    color: Colors.black.withOpacity(0.55),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    Icons.school,
                    color: Color(0xFF74bec9),
                  ),
                  SizedBox(
                    width: defaultSize * 0.3,
                  ),
                  Text(
                    'клас: $klass ',
                    style: TextStyle(
                      color: Color(0xFFf06388),
                    ),
                  ),
                  SizedBox(
                    width: defaultSize * 0.6,
                  ),
                  Expanded(
                    child: ButtonTheme(
                      height: defaultSize * 4.5,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              TaskOverviewScreen.routeName,
                              arguments: {'themeId': id, 'themeName': name});
                        },
                        elevation: 2.0,
                        highlightColor: Color(0xFF74bec9),
                        highlightElevation: 5.0,
                        child: Text(
                          ' Розпочати ',
                          style: TextStyle(color: Colors.white),
                        ),

                        color: blueRozoomColor,
                        // padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side:
                                BorderSide(color: Color(0xFF74bec9), width: 1)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: defaultSize * 0.6,
                  ),
                  Text(
                    'завдань: $tasksCount',
                    style: TextStyle(
                      color: Color(0xFFf06388),
                    ),
                  ),
                  SizedBox(
                    width: defaultSize * 0.3,
                  ),
                  Icon(Icons.school, color: Color(0xFF74bec9)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
