import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rozoom_app/widgets/button-animation.dart';

class TrainingProcessScreen0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/json/math.json', cache: false),
      builder: (context, snapshot) {
        List trainingData = json.decode(snapshot.data.toString());
        if (trainingData == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          return TrainingProcessItem(trainingData: trainingData);
        }
      },
    );
  }
}

class TrainingProcessItem extends StatefulWidget {
  final List trainingData;

  TrainingProcessItem({Key key, @required this.trainingData}) : super(key: key);
  @override
  _TrainingProcessItemState createState() =>
      _TrainingProcessItemState(trainingData);
}

class _TrainingProcessItemState extends State<TrainingProcessItem> {
  final GlobalKey<ButtonAnimationState> animatedButton =
      GlobalKey<ButtonAnimationState>();
  final List trainingData;
  _TrainingProcessItemState(this.trainingData);

  Color colortoshow = Color(0xFF74bec9);
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 1;
  bool disableAnswer = false;
  // extra varibale to iterate
  int j = 1;
  int timer = 30;
  String showtimer = "30";
  var random_array;

  Map<String, Color> btncolor = {
    "a": Color(0xFF74bec9),
    "b": Color(0xFF74bec9),
    "c": Color(0xFF74bec9),
    "d": Color(0xFF74bec9),
  };

  bool canceltimer = false;

  // code inserted for choosing questions randomly
  // to create the array elements randomly use the dart:math module
  // -----     CODE TO GENERATE ARRAY RANDOMLY

  genrandomarray() {
    var distinctIds = [];
    var rand = new Random();
    for (int i = 0;;) {
      distinctIds.add(rand.nextInt(10));
      random_array = distinctIds.toSet().toList();
      if (random_array.length < 10) {
        continue;
      } else {
        break;
      }
    }
    print(random_array);
  }

  //   var random_array;
  //   var distinctIds = [];
  //   var rand = new Random();
  //     for (int i = 0; ;) {
  //     distinctIds.add(rand.nextInt(10));
  //       random_array = distinctIds.toSet().toList();
  //       if(random_array.length < 10){
  //         continue;
  //       }else{
  //         break;
  //       }
  //     }
  //   print(random_array);

  // ----- END OF CODE
  // var random_array = [1, 6, 7, 2, 4, 10, 8, 3, 9, 5];

  // overriding the initstate function to start timer as this screen is created
  @override
  void initState() {
    starttimer();
    genrandomarray();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // overriding the setstate function to be called only if mounted
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        animatedButton.currentState.getProgressBar();
      });
    });
  }

  void nextquestion() {
    canceltimer = false;
    timer = 30;
    setState(() {
      if (j < 10) {
        i = random_array[j];
        j++;
      } else {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => resultpage(marks: marks),
        // ));
      }
      btncolor["a"] = Color(0xFF74bec9);
      btncolor["b"] = Color(0xFF74bec9);
      btncolor["c"] = Color(0xFF74bec9);
      btncolor["d"] = Color(0xFF74bec9);
      disableAnswer = false;
    });
    animatedButton.currentState.closeProgressBar();
    starttimer();
  }

  void checkanswer(String k) {
    // in the previous version this was
    // trainingData[2]["1"] == trainingData[1]["1"][k]
    // which i forgot to change
    // so nake sure that this is now corrected
    if (trainingData[2][i.toString()] == trainingData[1][i.toString()][k]) {
      // just a print sattement to check the correct working
      // debugPrint(trainingData[2][i.toString()] + " is equal to " + trainingData[1][i.toString()][k]);
      marks = marks + 5;
      // changing the color variable to be green
      colortoshow = right;
    } else {
      // just a print sattement to check the correct working
      // debugPrint(trainingData[2]["1"] + " is equal to " + trainingData[1]["1"][k]);
      colortoshow = wrong;
    }
    setState(() {
      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow;
      canceltimer = true;
      disableAnswer = true;
    });
    // nextquestion();
    // changed timer duration to 1 second
    Timer(Duration(seconds: 2), nextquestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          showtimer,
                          style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ButtonAnimation(
                          animatedButton,
                          Theme.of(context).accentColor,
                          Theme.of(context).accentColor),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        height: 300,
                        child: Text(
                          trainingData[0][i.toString()],
                          style:
                              TextStyle(fontSize: 50, color: Colors.grey[800]),
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: 6,
                child: AbsorbPointer(
                  absorbing: disableAnswer,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        choicebutton('a'),
                        choicebutton('b'),
                        choicebutton('c'),
                        choicebutton('d'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget choicebutton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        elevation: 5,
        onPressed: () {
          checkanswer(k);
        },
        child: Text(
          trainingData[1][i.toString()][k],
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}
