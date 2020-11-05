import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/constants.dart';
import 'package:rozoom_app/providers/time_provider.dart';
import 'package:rozoom_app/size_config.dart';

class TrainingNavbarItem extends StatefulWidget {
  @override
  _TrainingNavbarItemState createState() => _TrainingNavbarItemState();
}

class _TrainingNavbarItemState extends State<TrainingNavbarItem> {
  bool _isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void timer() {
    var timeState = Provider.of<TrainingTimer>(context, listen: false);
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeState.timer == 0) {
        // timer.cancel();
        timeState.timer = 20;
      } else {
        timeState.timer -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var timeState = Provider.of<TrainingTimer>(context);
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    int value = timeState.timer;
    int totalValue = 20;
    double ratio = value / totalValue;
    return Container(
      margin: EdgeInsets.only(bottom: defaultSize * 2),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: defaultSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  elevation: 15,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: defaultSize * 0.5),
                    width: defaultSize * 19.5,
                    alignment: Alignment.center,
                    height: defaultSize * 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '10',
                          style: TextStyle(
                              fontSize: defaultSize * 1.6,
                              color: textRozoomColor),
                        ),
                        Icon(
                          Icons.check,
                          color: Colors.greenAccent,
                        ),
                        Text(
                          '11',
                          style: TextStyle(
                              fontSize: defaultSize * 1.6,
                              color: textRozoomColor),
                        ),
                        Icon(
                          Icons.close,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: defaultSize * 0.3,
                        ),
                        Icon(
                          Icons.attach_money,
                          color: blueRozoomColor,
                        ),
                        Text(
                          '5.75',
                          style: TextStyle(
                              fontSize: defaultSize * 1.6,
                              color: textRozoomColor),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: defaultSize * 2,
                ),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                      width: defaultSize * 13.5,
                      alignment: Alignment.center,
                      height: defaultSize * 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                '?',
                                style: TextStyle(
                                    fontSize: defaultSize * 1.8,
                                    fontWeight: FontWeight.bold,
                                    color: blueRozoomColor),
                              ),
                              SizedBox(
                                width: defaultSize * 0.3,
                              ),
                              Text(
                                '11/12',
                                style: TextStyle(
                                    fontSize: defaultSize * 1.6,
                                    color: textRozoomColor),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.redAccent,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          Container(
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                  alignment: Alignment.center,
                  height: defaultSize * 4,
                  width: defaultSize * 35,
                  // color: blueRozoomColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            height: defaultSize * 1.5,
                            width: defaultSize * 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[400]),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(5),
                            child: AnimatedContainer(
                                height: defaultSize * 1.5,
                                width: defaultSize * 20 * ratio,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: (ratio < 0.3)
                                        ? Colors.redAccent
                                        : (ratio < 0.6)
                                            ? Colors.amber[400]
                                            : Colors.lightGreen),
                                duration: Duration(milliseconds: 500)),
                          )
                        ],
                      ),
                      Text(
                        timeState.timer.toString(),
                        style: TextStyle(
                            fontSize: defaultSize * 2.2,
                            color: textRozoomColor),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
