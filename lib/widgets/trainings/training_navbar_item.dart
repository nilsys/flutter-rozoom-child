import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/constants.dart';
import 'package:rozoom_app/providers/time_provider.dart';
import 'package:rozoom_app/providers/training_provider.dart';
import 'package:rozoom_app/screens/trainings/training_result_screen.dart';
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
        Provider.of<Training>(context, listen: false)
                .trainingItems['continueOrFinish']
                .continueOrFinish
            ? showAlert(context)
            : Provider.of<Training>(context, listen: false)
                .resultTraining(Provider.of<Training>(context, listen: false)
                    .trainingItems['sessionId']
                    .sessionId)
                .then((value) => Navigator.of(context)
                    .pushReplacementNamed(TrainingResultScreen.routeName));

        Provider.of<Training>(context, listen: false)
                .trainingItems['continueOrFinish']
                .continueOrFinish
            ? timeState.timer = 20
            : timer.cancel();
      } else if (timeState.timer == 22) {
        timer.cancel();
        print('timer canselled****************');
      } else {
        timeState.timer -= 1;
      }
    });
  }

  showAlert(BuildContext context) {
    Provider.of<Training>(context, listen: false)
        .answerTraining(
            Provider.of<Training>(context, listen: false)
                .trainingItems['answerId']
                .answerId,
            'null')
        .then((_) =>
            Provider.of<TrainingTimer>(context, listen: false).timer = 20)
        .then((_) => Navigator.of(context).pop(true));
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.red[50],
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.redAccent,
                    size: 250,
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var timeState = Provider.of<TrainingTimer>(context);
    // var training = Provider.of<TrainingModel>(context, listen: false);
    // var question = training.question;
    // print('question --------------------- $question');

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
                        Consumer<Training>(
                          builder: (ctx, item, _) => Text(
                            item.trainingItems['rightAnswersCount']
                                .rightAnswersCount,
                            style: TextStyle(
                                fontSize: defaultSize * 1.6,
                                color: textRozoomColor),
                          ),
                        ),
                        Icon(
                          Icons.check,
                          color: Colors.greenAccent,
                        ),
                        Consumer<Training>(
                          builder: (ctx, item, _) => Text(
                            item.trainingItems['wrongAnswersCount']
                                .wrongAnswersCount,
                            style: TextStyle(
                                fontSize: defaultSize * 1.6,
                                color: textRozoomColor),
                          ),
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
                        Consumer<Training>(
                          builder: (ctx, item, _) => Text(
                            item.trainingItems['rewardAmount'].rewardAmount,
                            style: TextStyle(
                                fontSize: defaultSize * 1.6,
                                color: textRozoomColor),
                          ),
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
                              Consumer<Training>(
                                builder: (ctx, item, _) => Text(
                                  '${item.trainingItems['currentQuestionNumber'].currentQuestionNumber}/${item.trainingItems['totalQuestionCount'].totalQuestionCount}',
                                  style: TextStyle(
                                      fontSize: defaultSize * 1.6,
                                      color: textRozoomColor),
                                ),
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
