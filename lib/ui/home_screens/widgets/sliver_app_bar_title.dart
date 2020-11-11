import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';

class SliverAppBarTitle extends StatelessWidget {
  const SliverAppBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'My Name',
          style: TextStyle(
              fontSize: defaultSize * 1.35,
              color: blueRozoomColor),
        ),
        SizedBox(
          height: defaultSize / 3,
        ),
        Text(
          'email@gmail.com',
          style: TextStyle(
              fontSize: defaultSize, color: pinkRozoomColor.withOpacity(0.7)),
        ),
        SizedBox(
          height: defaultSize / 3,
        ),
        // Text(
        //   '+380123456789',
        //   style: TextStyle(
        //       fontSize: defaultSize, color: textRozoomColor.withOpacity(0.7)),
        // ),
        // SizedBox(
        //   height: defaultSize / 2,
        // ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/stats/coin.png',
                scale: 0.9,
              ),
              SizedBox(width: defaultSize / 3),
              Text('222',
                  style: TextStyle(color: Colors.orange, fontSize: defaultSize)),
              SizedBox(width: defaultSize),
              Image.asset(
                'assets/images/stats/uah.png',
                scale: 5,
              ),
              SizedBox(width: defaultSize / 3),
              Text('11',
                  style: TextStyle(color: Colors.green, fontSize: defaultSize)),
            ],
          ),
        ),
      ],
    );
  }
}