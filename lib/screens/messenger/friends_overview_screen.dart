import 'package:flutter/material.dart';
import 'package:rozoom_app/pages/video_screen.dart';

import 'package:rozoom_app/widgets/messenger/friends_list.dart';

class FriendsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).accentColor,
      //   leading: Text(''),
      //   // title: Text(
      //   //   'Чат',
      //   //   style: TextStyle(
      //   //       fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
      //   // ),
      //   centerTitle: true,
      //   elevation: 0.0,
      //   actions: <Widget>[],
      // ),
      body: Container(
        child: Column(
          children: <Widget>[
            // FriendsOverviewNavBar(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Video(),
                    Expanded(
                      child: FriendsList(),
                    )
                  ],
                ),
              ),
            ),
            // Video(),
            // Expanded(
            //   child: FriendsList(),
            // ),
          ],
        ),
      ),
    );
  }
}
