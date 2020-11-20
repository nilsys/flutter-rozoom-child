import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/ui/profile_screen/edit_profile_screen.dart';

class SliverAppBarTitle extends StatelessWidget {
  const SliverAppBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Consumer<Profile>(
      builder: (context, profile, child) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            profile.profileItems['name'].name,
            style:
                TextStyle(fontSize: defaultSize * 1.35, color: blueRozoomColor),
          ),
          SizedBox(
            height: defaultSize / 3,
          ),
          Text(
            profile.profileItems['login'].login,
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
                Text(profile.profileItems['uom'].uom,
                    style:
                        TextStyle(color: Colors.orange, fontSize: defaultSize)),
                SizedBox(width: defaultSize),
                Image.asset(
                  'assets/images/stats/uah.png',
                  scale: 5,
                ),

                SizedBox(width: defaultSize / 3),
                Text(profile.profileItems['balance'].balance,
                    style:
                        TextStyle(color: Colors.green, fontSize: defaultSize)),
                SizedBox(width: defaultSize / 3),

                // IconButton(
                //     icon: Icon(
                //       Icons.edit_location,
                //       color: pinkRozoomColor,
                //       size: defaultSize * 2.0,
                //     ),
                // onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
