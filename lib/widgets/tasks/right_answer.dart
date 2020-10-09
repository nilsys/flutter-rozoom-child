import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/tasks/task_result_screen.dart';

class AnimatedRightAnswerDialog extends StatefulWidget {
  AnimatedRightAnswerDialog({this.answerIndex});
  final answerIndex;

  @override
  _AnimatedRightAnswerDialogState createState() =>
      _AnimatedRightAnswerDialogState();
}

class _AnimatedRightAnswerDialogState extends State<AnimatedRightAnswerDialog>
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
      begin: Offset(-1.0, 0.0),
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
      end: const Offset(-1.0, 0.0),
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
        backgroundColor: Colors.green,
        shape: CircleBorder(),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              // alignment: Alignment.centerRight,
              height: 300.0,
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Вірно!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
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
                      color: Colors.red,
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
              right: 190,
              child: Image.asset('assets/images/tasks/right-answer-boy.png'),
              height: 350,
            )
          ],
        ),
      ),
    );
  }
}
