import 'package:flutter/material.dart';
import 'package:rozoom_app/size_config.dart';

class TrainingQuestionItem extends StatelessWidget {
  const TrainingQuestionItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;

    return Container(
      margin: EdgeInsets.only(bottom: defaultSize * 2),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          alignment: Alignment.center,
          width: defaultSize * 35,
          height: defaultSize * 15,
          child: Text(
            '2198 < 2189',
            style: TextStyle(fontSize: 50, color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }
}
