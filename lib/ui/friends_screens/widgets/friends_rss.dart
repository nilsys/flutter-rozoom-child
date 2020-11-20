import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/friends_provider.dart';
import 'package:rozoom_app/shared/size_config.dart';

class FriendsRss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: defaultSize, vertical: defaultSize * 0.5),
        // color: pinkRozoomColor,
        child: SingleChildScrollView(
          child: Container(
            // padding: EdgeInsets.all(0),
            child: FriendsRssItem(),
          ),
        ),
      ),
    );
  }
}

class FriendsRssItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Consumer<Friends>(
      builder: (context, rss, child) => rss.rssMessageList.length == 0
          ? Center(
              child: Icon(
                Icons.child_care,
                color: Colors.yellowAccent,
                size: defaultSize * 3,
              ),
            )
          : ListView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: rss.rssMessageList.length,
              itemBuilder: (context, i) => Container(
                padding: EdgeInsets.only(
                    right: defaultSize * 1.5,
                    left: defaultSize * 1.5,
                    bottom: defaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          rss.rssMessageList[i].time,
                          style: TextStyle(fontSize: defaultSize * 1.6),
                        ),
                        SizedBox(
                          width: defaultSize * 0.5,
                        ),
                        Text(rss.rssMessageList[i].user,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: defaultSize * 1.8)),
                        SizedBox(
                          width: defaultSize * 0.5,
                        ),
                        Text(rss.rssMessageList[i].money,
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: defaultSize * 1.6)),
                        SizedBox(
                          width: defaultSize * 0.5,
                        ),
                        Image.asset('assets/images/stats/coin.png', scale: 0.55)
                      ],
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                      width: double.infinity,
                      // height: defaultSize * 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              rss.rssMessageList[i].body.toUpperCase(),
                              style: TextStyle(
                                  fontSize: defaultSize * 1.6,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ),
                          // Icon(
                          //   Icons.check,
                          //   color: Colors.green,
                          // ),
                          // SizedBox(
                          //   width: defaultSize * 0.3,
                          // ),
                          // Text('7'),
                          // SizedBox(
                          //   width: defaultSize * 0.3,
                          // ),
                          // Icon(
                          //   Icons.close,
                          //   color: Colors.red,
                          // ),
                          // SizedBox(
                          //   width: defaultSize * 0.3,
                          // ),
                          // Text('1'),
                          // SizedBox(
                          //   width: defaultSize * 0.3,
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
