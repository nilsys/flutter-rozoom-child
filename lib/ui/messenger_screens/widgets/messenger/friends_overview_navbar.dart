import 'package:flutter/material.dart';

class FriendsOverviewNavBar extends StatefulWidget {
  @override
  _FriendsOverviewNavBarState createState() => _FriendsOverviewNavBarState();
}

class _FriendsOverviewNavBarState extends State<FriendsOverviewNavBar> {
  int selectedIndex = 0;
  final List<String> categories = ['Чат', 'Видео', 'Друзья', 'Профиль'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              // child: Text(
              //   categories[index],
              //   style: TextStyle(
              //     color: index == selectedIndex ? Colors.white : Colors.white60,
              //     fontSize: 20.0,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.2,
              //   ),
              // ),
              child: Text(''),
            ),
          );
        },
      ),
    );
  }
}
