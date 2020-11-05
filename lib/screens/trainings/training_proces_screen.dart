import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/time_provider.dart';
import 'package:rozoom_app/size_config.dart';
import 'package:rozoom_app/widgets/components/app_bar.dart';
import 'package:rozoom_app/widgets/trainings/training_answer_item.dart';
import 'package:rozoom_app/widgets/trainings/training_navbar_item.dart';
import 'package:rozoom_app/widgets/trainings/training_question_item.dart';

class TrainingProcessScreen extends StatefulWidget {
  static const routeName = '/training-process';

  @override
  _TrainingProcessScreenState createState() => _TrainingProcessScreenState();
}

class _TrainingProcessScreenState extends State<TrainingProcessScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
      print('true');
    });
    Future.delayed(Duration(seconds: 5)).then((value) {
      setState(() {
        _isLoading = false;
        print('false');
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;

    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(context, '/training-themes-overview', '', '111',
            '5.00', false, false),
        body: _isLoading
            ? Center(child: Image.asset("assets/gifs/countdown.gif"))
            : SingleChildScrollView(
                child: ChangeNotifierProvider<TrainingTimer>(
                  create: (context) => TrainingTimer(),
                  child: Container(
                    margin: EdgeInsets.only(top: defaultSize * 2),
                    child: Column(
                      children: <Widget>[
                        TrainingNavbarItem(),
                        TrainingQuestionItem(),
                        TrainingAnswerItem(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
