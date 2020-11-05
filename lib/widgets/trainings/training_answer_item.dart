import 'package:flutter/material.dart';
import 'package:rozoom_app/constants.dart';
import 'package:rozoom_app/size_config.dart';

class TrainingAnswerItem extends StatelessWidget {
  const TrainingAnswerItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;

    return AbsorbPointer(
      absorbing: false,
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
    );
  }

  Widget choicebutton(String k) {
    double defaultSize = SizeConfig.defaultSize;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: defaultSize * 0.7,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        elevation: 5,
        onPressed: () {},
        child: Text(
          'Butto text',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: blueRozoomColor,
        splashColor: blueRozoomColor,
        highlightColor: blueRozoomColor,
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}
