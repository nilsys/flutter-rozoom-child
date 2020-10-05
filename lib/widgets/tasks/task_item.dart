import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;
  final String klass;
  final String tasksCount;
  TaskItem(this.id, this.name, this.imageUrl, this.klass, this.tasksCount);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(ThemesOverviewScreen.routeName,
        //     arguments: DisciplineItem(id, titleUa, imageUrl));
      },
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
                      fit: BoxFit.fill,
                      image: NetworkImage(imageUrl),
                      // fadeInDuration: Duration(seconds: 3),

                      // fadeOutDuration: Duration(seconds: 1),
                      placeholder: AssetImage('assets/images/brand.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 0,
                    child: Container(
                      width: 300,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      color: Colors.black54,
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
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
                          borderRadius: BorderRadius.circular(0.0),
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
          )),
    );
  }
}
