import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/training_provider.dart';
import 'package:rozoom_app/shared/size_config.dart';

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
          child: Consumer<Training>(
            builder: (ctx, item, _) => Text(
              item.trainingItems['question'].question,
              style: TextStyle(fontSize: 50, color: Colors.grey[800]),
            ),
          ),
        ),
      ),
    );
  }
}
