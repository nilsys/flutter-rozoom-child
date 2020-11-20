import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/task_provider.dart';
import 'package:rozoom_app/ui/tasks_screens/task_result_screen.dart';

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
    // final taskListen = Provider.of<Task>(context).taskItems;
    // var resultTrue = taskListen[0].continueOrFinish;
    return SlideTransition(
      position: _offsetAnimation,
      child: Dialog(
        backgroundColor: Colors.green,
        shape: CircleBorder(),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        child: Consumer<TaskModel>(
          builder: (ctx, task, child) => Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                // alignment: Alignment.centerRight,
                height: 350.0,
                width: 350.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Вірно!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    task.cardTitle == 'no card'
                        ? SizedBox()
                        : Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Ви отримали картку',
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15, right: 25, left: 25),
                                child: Text(
                                  task.cardTitle,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  width: 125,
                                  height: 125,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreen, width: 1)),
                                  child: Image.network(
                                    task.cardUrl,
                                    fit: BoxFit.fill,
                                    // width: 150,
                                    // height: 100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    Padding(
                        child: ButtonTheme(
                          minWidth: 80,
                          height: 45,
                          child: RaisedButton(
                            onPressed: () {
                              // Provider.of<Tasks>(context, listen: false).answerTask(
                              //     Provider.of<Tasks>(context, listen: false)
                              //         .getAnswerId,
                              //     widget.answerIndex);

                              // setState(() {

                              task.continueOrFinish
                                  ?
                                  // onOk();
                                  Navigator.pop(context)
                                  : Navigator.of(context).pushReplacementNamed(
                                      TaskResultScreen.routeName,
                                    );
                              // });
                            },
                            // elevation: 3.0,
                            // highlightColor: Color(0xFF74bec9),
                            highlightElevation: 5.0,
                            child: Text(
                              'Йдемо далі',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.red,
                            // padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(top: 5, bottom: 25)),
                  ],
                ),
              ),
              Positioned(
                top: 250,
                left: 0,
                child: Image.asset('assets/images/tasks/right-answer-boy.png'),
                height: 150,
              )
            ],
          ),
        ),
      ),
    );
  }
}
