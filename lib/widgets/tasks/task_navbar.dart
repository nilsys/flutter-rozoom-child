import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/widgets/tasks/green_icon.dart';
import 'package:rozoom_app/widgets/tasks/red_icon.dart';

class TaskNavbar extends StatelessWidget {
  const TaskNavbar({
    Key key,
    @required this.animatedStateKeyGreen,
    @required this.animatedStateKeyRed,
  }) : super(key: key);

  final GlobalKey<GreenAnimatedIconState> animatedStateKeyGreen;
  final GlobalKey<RedAnimatedIconState> animatedStateKeyRed;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (ctx, task, child) => Container(
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
                      task.rightAnswersCount,
                      style: TextStyle(color: Color(0xFFf06388), fontSize: 18),
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
                      task.wrongAnswersCount,
                      style: TextStyle(color: Color(0xFFf06388), fontSize: 18),
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
                      task.rewardAmount,
                      style: TextStyle(color: Color(0xFFf06388), fontSize: 18),
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
                      '${task.currentQuestionNumber}/${task.totalQuestionCount}',
                      style: TextStyle(color: Color(0xFFf06388), fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
