import 'package:flutter/material.dart';

class ThemeItem extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;
  final String klass;
  final String tasksCount;
  ThemeItem(this.id, this.name, this.imageUrl, this.klass, this.tasksCount);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(ThemesOverviewScreen.routeName,
        //     arguments: DisciplineItem(id, titleUa, imageUrl));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        elevation: 1,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
                child: FadeInImage(
                  image: NetworkImage(imageUrl),
                  // fadeInDuration: Duration(seconds: 3),

                  // fadeOutDuration: Duration(seconds: 1),
                  placeholder: AssetImage('assets/images/brand.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 5, right: 20, left: 20),
              child: Container(
                // height: 30,
                child: Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        Icons.school,
                        color: Color(0xFF74bec9),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'клас: $klass      ',
                        style: TextStyle(
                          color: Color(0xFFf06388),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {},
                    elevation: 2.0,
                    highlightColor: Color(0xFF74bec9),
                    highlightElevation: 5.0,
                    child: Text(
                      'Розпочати',
                      style: TextStyle(color: Color(0xFF74bec9)),
                    ),
                    color: Colors.white,
                    // padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Color(0xFF74bec9), width: 1)),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'завдань: $tasksCount',
                        style: TextStyle(
                          color: Color(0xFFf06388),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.school, color: Color(0xFF74bec9)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
