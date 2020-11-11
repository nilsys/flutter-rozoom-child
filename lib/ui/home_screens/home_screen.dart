import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:rozoom_app/ui/home_screens/widgets/home_block_1.dart';
import 'package:rozoom_app/ui/home_screens/widgets/home_block_2.dart';
import 'package:rozoom_app/ui/home_screens/widgets/home_block_3.dart';
import 'package:rozoom_app/ui/home_screens/widgets/sliver_app_bar_bg.dart';
import 'package:rozoom_app/ui/home_screens/widgets/sliver_app_bar_title.dart';


class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                // backgroundColor: pinkRozoomColor,
                automaticallyImplyLeading: false,
                expandedHeight: defaultSize * 29,
                floating: true,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: SliverAppBarTitle(),
                    background: HomeSliverAppBar()),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: defaultSize * 4, top: defaultSize * 3,),
                  child: Column(
                      children: [ 
                        Center(
                        child: Text(
                          'НАВЧАННЯ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pinkRozoomColor,
                              fontSize: 16),
                        ),                        
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultSize * 5, right: defaultSize * 5, top: defaultSize),
                      child: Divider(height: 2, color: blueRozoomColor),
                    ),   
                    ],
                  ),
                ),
                HomeBlock1(),
                Padding(
                  padding: EdgeInsets.only(bottom: defaultSize * 4, top: defaultSize * 4,),
                  child: Column(
                      children: [ 
                        Center(
                        child: Text(
                          'КОШИК',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pinkRozoomColor,
                              fontSize: 16),
                        ),                        
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultSize * 5, right: defaultSize * 5, top: defaultSize),
                      child: Divider(height: 2, color: blueRozoomColor),
                    ),   
                    ],
                  ),
                ),
                HomeBlock2(),
                Padding(
                  padding:  EdgeInsets.only(bottom: defaultSize * 4, top: defaultSize * 4,),
                  child: Column(
                      children: [ 
                        Center(
                        child: Text(
                          'ДОДАТКИ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pinkRozoomColor,
                              fontSize: 16),
                        ),                        
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultSize * 5, right: defaultSize * 5, top: defaultSize),
                      child: Divider(height: 2, color: blueRozoomColor),
                    ),   
                    ],
                  ),
                ),
                HomeBlock3(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}





