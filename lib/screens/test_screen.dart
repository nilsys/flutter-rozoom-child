import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: null),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/coin.svg',
                height: 35,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '364.60',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                'assets/images/uah.svg',
                height: 45,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '9',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Color(0xFFf06388),
          brightness: Brightness.light,
          elevation: 1,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
            Tab(
                icon: SvgPicture.asset(
                  "assets/images/bottom-icons/battles.svg",
                  width: 30,
                  height: 30,
                ),
                text: "Browse"),
            Icon(Icons.fitness_center, size: 30, color: Colors.white),
            Icon(Icons.star_border, size: 30, color: Colors.white),
            Icon(Icons.edit, size: 30, color: Colors.white),
            Icon(Icons.people_outline, size: 30, color: Colors.white),
          ],
          color: Color(0xFFf06388),
          buttonBackgroundColor: Color(0xFFf06388),
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(_page.toString(), textScaleFactor: 5.0),
                // RaisedButton(
                //   child: Text('Go To Page of index 1'),
                //   onPressed: () {
                //     final CurvedNavigationBarState navBarState =
                //         _bottomNavigationKey.currentState;
                //     navBarState.setPage(1);
                //   },
                // )
              ],
            ),
          ),
        ));
  }
}
