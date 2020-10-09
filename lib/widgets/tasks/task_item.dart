import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/widgets/tasks/green_icon.dart';
import 'package:rozoom_app/widgets/tasks/red_icon.dart';
import 'package:rozoom_app/widgets/tasks/right_answer.dart';
import 'package:rozoom_app/widgets/tasks/wrong_answer.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key key,
    @required this.themeName,
  }) : super(key: key);

  final String themeName;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final GlobalKey<GreenAnimatedIconState> animatedStateKeyGreen =
      GlobalKey<GreenAnimatedIconState>();

  final GlobalKey<RedAnimatedIconState> animatedStateKeyRed =
      GlobalKey<RedAnimatedIconState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GreenAnimatedIcon(key: animatedStateKeyGreen),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          Provider.of<Tasks>(context).getRightCount,
                          style:
                              TextStyle(color: Color(0xFFf06388), fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        RedAnimatedIcon(key: animatedStateKeyRed),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          Provider.of<Tasks>(context).getWrongCount,
                          style:
                              TextStyle(color: Color(0xFFf06388), fontSize: 18),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.attach_money,
                          color: Colors.black54,
                          size: 30,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          Provider.of<Tasks>(context).getReward,
                          style:
                              TextStyle(color: Color(0xFFf06388), fontSize: 18),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${Provider.of<Tasks>(context).getcurrentCount}/${Provider.of<Tasks>(context).getTotalCount}',
                          style:
                              TextStyle(color: Color(0xFFf06388), fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            width: double.infinity,
            // height: 200,
            child: Card(
              elevation: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ClipRRect(
                      // borderRadius: BorderRadius.all(
                      //   Radius.circular(30),
                      // ),
                      child: FadeInImage(
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            Provider.of<Tasks>(context).getImageUrl),
                        // fadeInDuration: Duration(seconds: 3),

                        // fadeOutDuration: Duration(seconds: 1),
                        placeholder: AssetImage('assets/images/brand.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 20, left: 20),
                    child: Container(
                      // height: 30,
                      child: Center(
                        child: Text(
                          Provider.of<Tasks>(context).getQuestion,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
              child: ListView.builder(
                  itemCount: Provider.of<Tasks>(context).getAnswers.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: EdgeInsets.only(top: 5),
                      child: ButtonTheme(
                        minWidth: 150,
                        height: 45,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(50.0),
                        //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                        child: RaisedButton(
                          onPressed: () {
                            Provider.of<Tasks>(context, listen: false)
                                .answerTask(
                                    Provider.of<Tasks>(context, listen: false)
                                        .getAnswerId,
                                    i);
                            print(
                                'right answer --------------> ${Provider.of<Tasks>(context, listen: false).rightAnswerValue}');
                            i.toString() ==
                                    Provider.of<Tasks>(context, listen: false)
                                        .getRightAnswer
                                        .toString()
                                ? animatedStateKeyGreen.currentState
                                    .getAnimationFromChild()
                                : animatedStateKeyRed.currentState
                                    .getAnimationFromChild();
                            i.toString() ==
                                    Provider.of<Tasks>(context, listen: false)
                                        .getRightAnswer
                                        .toString()
                                ? _showOyboyRightAnswerDialog(i)
                                : _showOyboyWrongAnswerDialog(i);
                          },
                          elevation: 3.0,
                          highlightColor: Color(0xFF74bec9),
                          highlightElevation: 5.0,
                          child: Text(
                            Provider.of<Tasks>(context).getAnswers[i] != null
                                ? Provider.of<Tasks>(context).getAnswers[i]
                                : '',
                            style: TextStyle(
                                color: Color(0xFF74bec9),
                                fontWeight: FontWeight.bold),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                  color: Color(0xFF74bec9), width: 2)),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void _showOyboyRightAnswerDialog(i) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AnimatedRightAnswerDialog(answerIndex: i),
    );
  }

  void _showOyboyWrongAnswerDialog(i) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AnimatedWrongAnswerDialog(answerIndex: i),
    );
  }
}
