import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/core/providers/time_provider.dart';
import 'package:rozoom_app/core/providers/training_provider.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/loader_widget.dart';
import 'package:rozoom_app/ui/training_screens/widgets/training_answer_item.dart';
import 'package:rozoom_app/ui/training_screens/widgets/training_navbar_item.dart';
import 'package:rozoom_app/ui/training_screens/widgets/training_question_item.dart';

class TrainingProcessScreen extends StatefulWidget {
  static const routeName = '/training-process';

  @override
  _TrainingProcessScreenState createState() => _TrainingProcessScreenState();
}

class _TrainingProcessScreenState extends State<TrainingProcessScreen> {
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final String trainingId = args['trainingId'];
      Provider.of<Training>(context, listen: false)
          .startTraining(trainingId)
          .then((value) => setState(() {
                isLoading = false;
              }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: Colors.grey,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          actions: <Widget>[],
          title: Consumer<Profile>(
            builder: (ctx, profile, child) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 35),
                Image.asset('assets/images/stats/coin.png', scale: 0.55),
                SizedBox(width: 5),
                profile.isLoadingScreen
                    ? SizedBox(
                        child: myLoaderWidget(),
                        width: defaultSize * 5,
                      )
                    : Text(profile.profileItems['uom'].uom,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(width: 10),
                Image.asset('assets/images/stats/uah.png', height: 30),
                SizedBox(width: 5),
                profile.isLoadingScreen
                    ? SizedBox(
                        child: myLoaderWidget(),
                        width: defaultSize * 5,
                      )
                    : Text(profile.profileItems['balance'].balance,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ),
        body: isLoading
            ? Center(child: Image.asset("assets/gifs/ripple.gif"))
            : SingleChildScrollView(
                child: ChangeNotifierProvider<TrainingTimer>(
                  create: (context) => TrainingTimer(),
                  child: Container(
                    margin: EdgeInsets.only(top: defaultSize * 2),
                    child: Column(
                      children: <Widget>[
                        TrainingNavbarItem(),
                        TrainingQuestionItem(),
                        TrainingAnswerItem(isLoading: isLoading),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
