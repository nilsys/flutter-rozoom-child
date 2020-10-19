import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/profile_provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/widgets/tasks/green_icon.dart';
import 'package:rozoom_app/widgets/tasks/red_icon.dart';
import 'package:rozoom_app/widgets/tasks/right_answer.dart';
import 'package:rozoom_app/widgets/tasks/wrong_answer.dart';
import 'package:audioplayers/audioplayers.dart';

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

  final _answerFieldController = TextEditingController();

  AudioPlayer audioPlayer = AudioPlayer();
  bool playing = false;

  @override
  void dispose() {
    _answerFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<TaskModel>(
        builder: (ctx, task, child) => Column(
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
                            task.rightAnswersCount,
                            style: TextStyle(
                                color: Color(0xFFf06388), fontSize: 18),
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
                            style: TextStyle(
                                color: Color(0xFFf06388), fontSize: 18),
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
                            style: TextStyle(
                                color: Color(0xFFf06388), fontSize: 18),
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
                            style: TextStyle(
                                color: Color(0xFFf06388), fontSize: 18),
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
                          image: NetworkImage(task.imageUrl),
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
                            task.question,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    task.audioQuestion == 'no audio'
                        ? Text('')
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20),
                            child: Container(
                              // height: 30,
                              child: Center(
                                child: InkWell(
                                  onTap: () async {
                                    playAudio(task.audioQuestion);
                                  },
                                  child: Icon(
                                    playing == false
                                        ? Icons.play_circle_outline
                                        : Icons.pause_circle_outline,
                                    color: Color(0xFF74bec9),
                                    size: 34,
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
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
                child: getTaskId(task),
              ),
            ),
          ],
        ),
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

  void playAudio(url) async {
    if (playing) {
      var res = await audioPlayer.stop();
      if (res == 1) {
        setState(() {
          playing = false;
        });
      }
    } else {
      var res = await audioPlayer.play(url);
      if (res == 1) {
        setState(() {
          playing = true;
        });
      }
    }
  }

  Widget getTaskId(task) {
    final taskId = Provider.of<TaskModel>(context, listen: false).getAnswerType;
    print('task id ------> $taskId');
    switch (taskId) {
      case '1':
        return buttonAnswerType(task);
      case '2':
        return formAnswerType(task);
      case '3':
        return imageAnswerType(task);
    }
    return buttonAnswerType(task);
  }

  Widget buttonAnswerType(task) {
    return ListView.builder(
        itemCount: task.answerVariants.length,
        itemBuilder: (ctx, i) {
          return task.audioQuestion == 'no audio'
              ? Container(
                  margin: EdgeInsets.only(top: 5),
                  child: ButtonTheme(
                    minWidth: 150,
                    height: 45,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(50.0),
                    //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    child: RaisedButton(
                      onPressed: () {
                        Provider.of<TaskModel>(context, listen: false)
                            .answerTask(task.answerIdForApi, i);

                        i.toString() == task.rightAnswerListElementNumber
                            ? animatedStateKeyGreen.currentState
                                .getAnimationFromChild()
                            : animatedStateKeyRed.currentState
                                .getAnimationFromChild();
                        i.toString() == task.rightAnswerListElementNumber
                            ? _showOyboyRightAnswerDialog(i)
                            : _showOyboyWrongAnswerDialog(i);
                      },
                      elevation: 3.0,
                      highlightColor: Color(0xFF74bec9),
                      highlightElevation: 5.0,
                      child: Text(
                        task.answerVariants[i] != null
                            ? task.answerVariants[i]
                            : '',
                        style: TextStyle(
                            color: Color(0xFF74bec9),
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: ButtonTheme(
                        minWidth: 150,
                        height: 45,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(50.0),
                        //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                        child: RaisedButton(
                          onPressed: () {
                            Provider.of<TaskModel>(context, listen: false)
                                .answerTask(task.answerIdForApi, i);

                            i.toString() == task.rightAnswerListElementNumber
                                ? animatedStateKeyGreen.currentState
                                    .getAnimationFromChild()
                                : animatedStateKeyRed.currentState
                                    .getAnimationFromChild();
                            i.toString() == task.rightAnswerListElementNumber
                                ? _showOyboyRightAnswerDialog(i)
                                : _showOyboyWrongAnswerDialog(i);
                          },
                          elevation: 3.0,
                          highlightColor: Color(0xFF74bec9),
                          highlightElevation: 5.0,
                          child: Text(
                            task.answerVariants[i] != null
                                ? task.answerVariants[i]
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
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        playAudio(task.audioQuestion);
                      },
                      child: Icon(
                        playing == false
                            ? Icons.play_circle_outline
                            : Icons.pause_circle_outline,
                        color: Color(0xFF74bec9),
                        size: 34,
                      ),
                    ),
                  ],
                );
        });
  }

  Widget formAnswerType(task) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _answerFieldController,
              // obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
              },
              decoration: InputDecoration(
                hintText: 'Впишіть відповідь',
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Provider.of<TaskModel>(context, listen: false).answerTaskWithForm(
                  task.answerIdForApi, _answerFieldController.text);
              print(
                  '_answerFieldController.text ------- ${_answerFieldController.text}');

              print(
                  'rightAnswerStringValue ------- ${task.rightAnswerStringValue}');

              _answerFieldController.text == task.rightAnswerStringValue
                  ? animatedStateKeyGreen.currentState.getAnimationFromChild()
                  : animatedStateKeyRed.currentState.getAnimationFromChild();
              _answerFieldController.text == task.rightAnswerStringValue
                  ? _showOyboyRightAnswerDialog('text')
                  : _showOyboyWrongAnswerDialog('text');
              _answerFieldController.clear();
            },
            elevation: 3.0,
            highlightColor: Color(0xFF74bec9),
            highlightElevation: 5.0,
            child: Text(
              'Відповісти',
              style: TextStyle(
                  color: Color(0xFF74bec9), fontWeight: FontWeight.bold),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Color(0xFF74bec9), width: 2)),
          ),
        ],
      ),
    );
  }

  Widget imageAnswerType(task) {
    return GridView.builder(
        itemCount: task.answerVariants.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) {
          return Container(
            margin: EdgeInsets.only(top: 5),
            // child: ButtonTheme(
            //   minWidth: 150,
            //   height: 45,
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(50.0),
            //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
            child: FlatButton(
              onPressed: () {
                Provider.of<TaskModel>(context, listen: false)
                    .answerTask(task.answerIdForApi, i);

                i.toString() == task.rightAnswerListElementNumber
                    ? animatedStateKeyGreen.currentState.getAnimationFromChild()
                    : animatedStateKeyRed.currentState.getAnimationFromChild();
                i.toString() == task.rightAnswerListElementNumber
                    ? _showOyboyRightAnswerDialog(i)
                    : _showOyboyWrongAnswerDialog(i);
              },
              // elevation: 3.0,
              highlightColor: Color(0xFF74bec9),
              // highlightElevation: 5.0,
              // child: Text(
              //   task.answerVariants[i] != null ? task.answerVariants[i] : '',
              //   style: TextStyle(
              //       color: Color(0xFF74bec9), fontWeight: FontWeight.bold),
              // ),
              child: FadeInImage(
                width: 100,
                height: 100,
                // fit: BoxFit.contain,
                image: NetworkImage(
                    'https://rozoom.com.ua/uploads/' + task.answerVariants[i]),
                // fadeInDuration: Duration(seconds: 3),

                // fadeOutDuration: Duration(seconds: 1),
                placeholder: AssetImage('assets/images/brand.png'),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color(0xFF74bec9), width: 2)),
            ),
            // ),
          );
        });
  }
}
