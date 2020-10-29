import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/widgets/tasks/green_icon.dart';
import 'package:rozoom_app/widgets/tasks/red_icon.dart';
import 'package:rozoom_app/widgets/tasks/right_answer.dart';
import 'package:rozoom_app/widgets/tasks/task_navbar.dart';
import 'package:rozoom_app/widgets/tasks/task_question.dart';
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

  final GlobalKey<TaskQuestionState> taskQuestionState =
      GlobalKey<TaskQuestionState>();

  final _form = GlobalKey<FormState>();
  final _answerFieldController = TextEditingController();

  AudioPlayer audioPlayer_0 = AudioPlayer();
  AudioPlayer audioPlayer_1 = AudioPlayer();
  AudioPlayer audioPlayer_2 = AudioPlayer();
  AudioPlayer audioPlayer_3 = AudioPlayer();
  List audioPlayer;

  static bool p0 = false;
  static bool p1 = false;
  static bool p2 = false;
  static bool p3 = false;
  List playings = [p0, p1, p2, p3];

  @override
  void dispose() {
    _answerFieldController.dispose();
    super.dispose();
  }

  void playAudio(url, i) async {
    audioPlayer = [audioPlayer_0, audioPlayer_1, audioPlayer_2, audioPlayer_3];

    if (playings[i]) {
      var res = await audioPlayer[i].stop();
      if (res == 1) {
        setState(() {
          playings[i] = false;
        });
      }
    } else {
      var res = await audioPlayer[i].play(url);
      if (res == 1) {
        setState(() {
          playings[i] = true;
          print('playing $i from function --- true');
        });
      }
    }
  }

  void stopAudio() async {
    audioPlayer = [audioPlayer_0, audioPlayer_1, audioPlayer_2, audioPlayer_3];
    for (var i = 0; i < audioPlayer.length; i++) {
      if (playings[i]) {
        var res = await audioPlayer[i].stop();
        if (res == 1) {
          setState(() {
            playings[i] = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final taskName = Provider.of<ThemeItem>(context).name;
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // имя темы в заголовке задания

            // Container(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 10.0, left: 15.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: <Widget>[
            //         Text(
            //           widget.themeName,
            //           style: TextStyle(color: Color(0xFF74bec9), fontSize: 16),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            TaskNavbar(
                animatedStateKeyGreen: animatedStateKeyGreen,
                animatedStateKeyRed: animatedStateKeyRed),
            TaskQuestion(key: taskQuestionState),
            Consumer<TaskModel>(
              builder: (ctx, task, child) => Container(
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

  Widget getTaskId(task) {
    final taskId = Provider.of<TaskModel>(context, listen: false).getAnswerType;
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
    // final playingLEN =
    // Provider.of<TaskModel>(context, listen: false).audioAnswer_0;
    // final taskId = Provider.of<TaskModel>(context, listen: false).getAnswerType;
    return ListView.builder(
        itemCount: task.answerVariants.length,
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          return task.audioAnswer[i] == 'no audio'
              ? Container(
                  margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: ButtonTheme(
                    minWidth: 150,
                    height: 45,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(50.0),
                    //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    child: RaisedButton(
                      onPressed: () async {
                        taskQuestionState.currentState.stopAudioFromChild();
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
              : Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: ButtonTheme(
                            minWidth: 150,
                            height: 45,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(50.0),
                            //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                            child: RaisedButton(
                              onPressed: () {
                                stopAudio();
                                taskQuestionState.currentState
                                    .stopAudioFromChild();
                                Provider.of<TaskModel>(context, listen: false)
                                    .answerTask(task.answerIdForApi, i);

                                i.toString() ==
                                        task.rightAnswerListElementNumber
                                    ? animatedStateKeyGreen.currentState
                                        .getAnimationFromChild()
                                    : animatedStateKeyRed.currentState
                                        .getAnimationFromChild();
                                i.toString() ==
                                        task.rightAnswerListElementNumber
                                    ? _showOyboyRightAnswerDialog(i)
                                    : _showOyboyWrongAnswerDialog(i);

                                // Provider.of<TaskModel>(context, listen: false)
                                //     .nullAudio();
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
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            playAudio(task.audioAnswer[i], i);
                          },
                          child: Icon(
                            playings[i] == false
                                ? Icons.play_circle_outline
                                : Icons.pause_circle_outline,
                            color: Color(0xFF74bec9),
                            size: 34,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        });
  }

  Widget formAnswerType(task) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _form,
        child: TextFormField(
          controller: _answerFieldController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            final isValid = _form.currentState.validate();
            if (!isValid) {
              return;
            }
            Provider.of<TaskModel>(context, listen: false).answerTaskWithForm(
                task.answerIdForApi, _answerFieldController.text);

            _answerFieldController.text == task.rightAnswerStringValue
                ? animatedStateKeyGreen.currentState.getAnimationFromChild()
                : animatedStateKeyRed.currentState.getAnimationFromChild();
            _answerFieldController.text == task.rightAnswerStringValue
                ? _showOyboyRightAnswerDialog('text')
                : _showOyboyWrongAnswerDialog('text');
            _answerFieldController.clear();
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Дайте відповідь';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Впишіть відповідь',
            suffixIcon: IconButton(
              onPressed: () {
                final isValid = _form.currentState.validate();
                if (!isValid) {
                  return;
                }
                Provider.of<TaskModel>(context, listen: false)
                    .answerTaskWithForm(
                        task.answerIdForApi, _answerFieldController.text);

                _answerFieldController.text == task.rightAnswerStringValue
                    ? animatedStateKeyGreen.currentState.getAnimationFromChild()
                    : animatedStateKeyRed.currentState.getAnimationFromChild();
                _answerFieldController.text == task.rightAnswerStringValue
                    ? _showOyboyRightAnswerDialog('text')
                    : _showOyboyWrongAnswerDialog('text');
                _answerFieldController.clear();
              },
              icon: Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
                size: 36,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageAnswerType(task) {
    return GridView.builder(
        itemCount: task.answerVariants.length,
        shrinkWrap: true,
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
