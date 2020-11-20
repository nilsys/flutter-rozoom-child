import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/size_config.dart';

class FriendsOverviewHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      margin: EdgeInsets.all(defaultSize * 0.5),
      padding: EdgeInsets.only(
          left: defaultSize * 2,
          right: defaultSize * 2,
          top: defaultSize * 1.5,
          bottom: defaultSize),
      // color: pinkRozoomColor.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://rozoom.com.ua/uploads/avatars/eUTzppo49KB3LfOkovsCNcCQk4LBmxCTsMShFlmZ.jpeg"),
                    fit: BoxFit.cover)),
          ),
          Text(
            "Друзі",
            style: TextStyle(
                fontSize: defaultSize * 2.2, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
