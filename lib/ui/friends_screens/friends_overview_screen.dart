import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/friends_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';
import 'package:rozoom_app/ui/friends_screens/widgets/friends_overview_header.dart';
import 'package:rozoom_app/ui/friends_screens/widgets/friends_rss.dart';
import 'package:rozoom_app/ui/friends_screens/widgets/friends_list.dart';

class FriendsOverviewScreen extends StatelessWidget {
  final String id;
  FriendsOverviewScreen({this.id});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Consumer<Friends>(
      builder: (context, friend, child) => friend.isLoadingScreen
          ? MyLoaderScreen()
          : Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    FriendsOverviewHeader(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: defaultSize * 5,
                          right: defaultSize * 5,
                          bottom: defaultSize * 0.5),
                      child: Divider(
                        color: blueRozoomColor,
                        height: 3,
                      ),
                    ),
                    FriendsList(id: id),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: defaultSize * 0.5),
                      child: Divider(
                        color: blueRozoomColor,
                        height: 3,
                      ),
                    ),
                    FriendsRss(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: defaultSize * 0.5),
                      child: Divider(
                        color: blueRozoomColor,
                        height: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
