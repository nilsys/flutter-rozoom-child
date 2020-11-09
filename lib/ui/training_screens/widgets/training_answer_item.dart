import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/time_provider.dart';
import 'package:rozoom_app/core/providers/training_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/ui/training_screens/training_result_screen.dart';
import 'package:rozoom_app/shared/size_config.dart';

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
    return AbsorbPointer(
      absorbing: false,
      child: Container(
        child: Consumer<Training>(
          builder: (ctx, item, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[buttonAnswerType(item.trainingItems)],
          ),
        ),
      ),
    );
  }

  Widget buttonAnswerType(trainingItems) {
    double defaultSize = SizeConfig.defaultSize;
    //Правильный ответ
    bool isRightAnswer;
    bool result = trainingItems['continueOrFinish'].continueOrFinish;

    String answerId = trainingItems['answerId'].answerId;
    String sessionId = trainingItems['sessionId'].sessionId;
    return ListView.builder(
        itemCount: trainingItems['answerVariants'].answerVariants.length,
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          //Ответ на i кнопке String
          String answerString =
              trainingItems['answerVariants'].answerVariants[i];
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: defaultSize * 0.7,
              horizontal: defaultSize * 3,
            ),
            child: MaterialButton(
              elevation: 5,
              onPressed: () {
                //Ответ кнопки == Правильный ответ? Для ShowDialog
                answerString == trainingItems['rightAnswer'].rightAnswer
                    ? isRightAnswer = true
                    : isRightAnswer = false;
                showAlert(context, answerString, answerId, sessionId,
                    isRightAnswer, result);
              },
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      answerString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                      maxLines: 1,
                    ),
              color: blueRozoomColor,
              splashColor: blueRozoomColor,
              highlightColor: blueRozoomColor,
              minWidth: 200.0,
              height: 45.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          );
        });
  }

  showAlert(BuildContext context, answerString, answerId, sessionId,
      isRightAnswer, result) {
    result
        ? Provider.of<Training>(context, listen: false)
            .answerTraining(answerId, answerString)
            .then((_) =>
                Provider.of<TrainingTimer>(context, listen: false).timer = 20)
            .then((_) => Navigator.of(context).pop(true))
        : Provider.of<Training>(context, listen: false)
            .answerTrainingNoListen(answerId, answerString)
            .then((_) => Provider.of<Training>(context, listen: false)
                .resultTraining(sessionId))
            .then((_) =>
                Provider.of<TrainingTimer>(context, listen: false).timer = 22)
            .then((_) => Navigator.of(context)
                .pushReplacementNamed(TrainingResultScreen.routeName));

    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.white10,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: isRightAnswer
                      ? Icon(
                          Icons.check,
                          color: Colors.greenAccent,
                          size: 250,
                        )
                      : Icon(
                          Icons.close,
                          color: Colors.redAccent,
                          size: 250,
                        )),
            ));
  }
}
