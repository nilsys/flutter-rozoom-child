import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/task_provider.dart';
import 'package:rozoom_app/ui/tasks_screens/task_result_screen.dart';

class AnimatedWrongAnswerDialog extends StatefulWidget {
  AnimatedWrongAnswerDialog({this.answerIndex});
  final answerIndex;

  @override
  _AnimatedWrongAnswerDialogState createState() =>
      _AnimatedWrongAnswerDialogState();
}

class _AnimatedWrongAnswerDialogState extends State<AnimatedWrongAnswerDialog>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..animateTo(1.0);
    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onOk() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..animateTo(1.0);
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var rightAnswerStringValue =
        Provider.of<TaskModel>(context, listen: false).rightAnswerStringValue;
    var explainText =
        Provider.of<TaskModel>(context, listen: false).explainText;
    var answerType = Provider.of<TaskModel>(context, listen: false).answerType;

    return SlideTransition(
      position: _offsetAnimation,
      child: Dialog(
        backgroundColor: Colors.red,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        shape: CircleBorder(),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              // margin: EdgeInsets.all(15),
              height: 350.0,
              width: 350.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 45),
                    child: Text(
                      'Невірно:(',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  answerType == '3'
                      ? Text('')
                      : Expanded(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Center(
                                  child: Text(
                                    'Вірна відповідь:',
                                    style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 15, right: 25, left: 25),
                                  child: Text(
                                    rightAnswerStringValue,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 45, right: 45),
                                child: Text(
                                  // explainText.length > 250
                                  //     ? explainText.replaceRange(
                                  //         250, explainText.length, '...')
                                  //     :
                                  explainText,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Padding(
                      child: Consumer<TaskModel>(
                        builder: (ctx, task, child) => ButtonTheme(
                          minWidth: 80,
                          height: 45,
                          child: RaisedButton(
                            onPressed: () {
                              task.continueOrFinish
                                  ? Navigator.pop(context)
                                  : Navigator.of(context).pushReplacementNamed(
                                      TaskResultScreen.routeName,
                                    );
                            },
                            highlightElevation: 5.0,
                            child: Text(
                              'Я зрозумів',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 15.0, bottom: 55)),
                ],
              ),
            ),
            Positioned(
              top: 250,
              left: 230,
              child: Image.asset('assets/images/tasks/wrong-answer-boy.png'),
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
