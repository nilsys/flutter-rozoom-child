import 'package:flutter/material.dart';
import 'package:rozoom_app/size_config.dart';

AppBar myAppBar(
    BuildContext context, String title, String balance, String certificates) {
  return AppBar(
    // leading: Icon(
    //   Icons.arrow_back,
    //   color: Colors.grey,

    // ),

    elevation: 1,
    backgroundColor: Colors.white,

    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(width: 35),
            Image.asset(
              'assets/images/stats/coin.png',
              scale: 0.55,
            ),
            SizedBox(width: 5),
            balance != null
                ? Text(balance,
                    style: TextStyle(color: Colors.black, fontSize: 16))
                : Text(''),
            SizedBox(width: 10),
            Image.asset('assets/images/stats/uah.png',
                height: SizeConfig.defaultSize * 3.0),
            SizedBox(width: 5),
            certificates != null
                ? Text(certificates,
                    style: TextStyle(color: Colors.black, fontSize: 16))
                : Text(''),
          ],
        ),
      ],
    ),
    actions: <Widget>[
      Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
    ],
  );
}
