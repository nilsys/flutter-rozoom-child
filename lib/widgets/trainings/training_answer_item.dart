import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/constants.dart';
import 'package:rozoom_app/providers/time_provider.dart';
import 'package:rozoom_app/providers/training_provider.dart';
import 'package:rozoom_app/screens/trainings/training_result_screen.dart';
import 'package:rozoom_app/screens/trainings/trainings_overview_screen.dart';
import 'package:rozoom_app/size_config.dart';

class TrainingAnswerItem extends StatefulWidget {
  final isLoading;
  const TrainingAnswerItem({
    this.isLoading,
  });

  @override
  _TrainingAnswerItemState createState() => _TrainingAnswerItemState();
}

class _TrainingAnswerItemState extends State<TrainingAnswerItem> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    double screenHeight = SizeConfig.screenHeight;
    double screenWidth = SizeConfig.screenWidth;
    return AbsorbPointer(
      absorbing: false,
      child: Container(
        child: Consumer<Training>(
          builder: (ctx, item, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              choicebutton(
                  context,
                  item.trainingItems['rightAnswer'].rightAnswer,
                  item.trainingItems['answerVariants'].answerVariants[0],
                  item.trainingItems['answerId'].answerId,
                  item.trainingItems['sessionId'].sessionId),
              choicebutton(
                  context,
                  item.trainingItems['rightAnswer'].rightAnswer,
                  item.trainingItems['answerVariants'].answerVariants[1],
                  item.trainingItems['answerId'].answerId,
                  item.trainingItems['sessionId'].sessionId),
              choicebutton(
                  context,
                  item.trainingItems['rightAnswer'].rightAnswer,
                  item.trainingItems['answerVariants'].answerVariants[2],
                  item.trainingItems['answerId'].answerId,
                  item.trainingItems['sessionId'].sessionId),
              choicebutton(
                  context,
                  item.trainingItems['rightAnswer'].rightAnswer,
                  item.trainingItems['answerVariants'].answerVariants[3],
                  item.trainingItems['answerId'].answerId,
                  item.trainingItems['sessionId'].sessionId),
            ],
          ),
        ),
      ),
    );
  }

  Widget choicebutton(BuildContext context, String rightAnswer,
      String answerStringValue, String answerId, String sessionId) {
    double defaultSize = SizeConfig.defaultSize;
    bool isRight;
    answerStringValue == rightAnswer ? isRight = true : isRight = false;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: defaultSize * 0.7,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        elevation: 5,
        onPressed: () {
          Provider.of<Training>(context, listen: false)
                  .trainingItems['continueOrFinish']
                  .continueOrFinish
              ? showAlert(context, answerId, answerStringValue, isRight)
              : showExitAlert(
                  context, answerId, answerStringValue, isRight, sessionId);
        },
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Text(
                answerStringValue,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                maxLines: 1,
              ),
        color: blueRozoomColor,
        splashColor: blueRozoomColor,
        highlightColor: blueRozoomColor,
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  showAlert(BuildContext context, answerId, answerStringValue, isRight) {
    Provider.of<Training>(context, listen: false)
        .answerTraining(answerId, answerStringValue)
        .then((_) =>
            Provider.of<TrainingTimer>(context, listen: false).timer = 20)
        .then((_) => Navigator.of(context).pop(true));
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: isRight ? Colors.white10 : Colors.white10,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: isRight
                      ? Icon(
                          Icons.check,
                          color: Colors.greenAccent,
                          size: 250,
                        )
                      : Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                          size: 250,
                        )),
            ));
  }

  showExitAlert(
      BuildContext context, answerId, answerStringValue, isRight, sessionId) {
    Provider.of<Training>(context, listen: false)
        .answerTrainingNoListen(answerId, answerStringValue)
        .then((_) => Provider.of<Training>(context, listen: false)
            .resultTraining(sessionId))
        .then((_) =>
            Provider.of<TrainingTimer>(context, listen: false).timer = 22)
        .then((_) => Navigator.of(context)
            .pushReplacementNamed(TrainingResultScreen.routeName));
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: isRight ? Colors.white10 : Colors.white10,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: isRight
                      ? Icon(
                          Icons.check,
                          color: Colors.greenAccent,
                          size: 250,
                        )
                      : Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                          size: 250,
                        )),
            ));
  }
}
