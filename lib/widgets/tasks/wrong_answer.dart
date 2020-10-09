import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/tasks/task_result_screen.dart';

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
    return SlideTransition(
      position: _offsetAnimation,
      child: Dialog(
        backgroundColor: Colors.red,
        shape: CircleBorder(),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              height: 300.0,
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 30.0, top: 5),
                    child: Text(
                      'Невірно:(',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 50.0, right: 100, top: 20, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'Вірна відповідь:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50.0, right: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            Provider.of<Tasks>(context).rightAnswerValue,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  ButtonTheme(
                    minWidth: 80,
                    height: 45,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(50.0),
                    //     side: BorderSide(color: Color(0xFF74bec9), width: 2)),
                    child: RaisedButton(
                      onPressed: () {
                        // Provider.of<Tasks>(context, listen: false).answerTask(
                        //     Provider.of<Tasks>(context, listen: false)
                        //         .getAnswerId,
                        //     widget.answerIndex);
                        print(
                            'result ----------------------> ${Provider.of<Tasks>(context, listen: false).getResult}');
                        setState(() {
                          Provider.of<Tasks>(context, listen: false).getResult
                              ? Future.delayed(Duration.zero).then((_) {
                                  onOk();
                                  Navigator.pop(context);
                                })
                              : Navigator.of(context).pushNamed(
                                  TaskResultScreen.routeName,
                                );
                        });
                      },
                      // elevation: 3.0,
                      // highlightColor: Color(0xFF74bec9),
                      highlightElevation: 5.0,
                      child: Text(
                        'Йдемо далі',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.green,
                      // padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 190,
              child: Image.asset('assets/images/tasks/wrong-answer-boy.png'),
              height: 350,
            )
          ],
        ),
      ),
    );
  }
}
