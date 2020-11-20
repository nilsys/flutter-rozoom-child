import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/widgets/loader_widget.dart';
import 'package:rozoom_app/ui/training_screens/training_process_screen.dart';
import 'package:rozoom_app/shared/size_config.dart';

class TrainingPreviewScreen extends StatelessWidget {
  static const routeName = '/training-preview';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    // final task = Provider.of<Task>(context).taskItems;
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String trainingName = args['trainingName'];
    final String trainingId = args['trainingId'];
    final String trainingImageUrl = args['trainingImageUrl'];

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[],
        title: Consumer<Profile>(
          builder: (ctx, profile, child) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      trainingName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: defaultSize * 0.5,
                  ),
                  Tooltip(
                    height: 100,
                    decoration: BoxDecoration(
                        color: pinkRozoomColor, shape: BoxShape.rectangle),
                    padding: EdgeInsets.all(defaultSize),
                    margin: EdgeInsets.symmetric(horizontal: defaultSize * 5),
                    message:
                        'Тренування містить 12 задач. На кожну відповідь надається 20 секунд. Успіху!',
                    child: Icon(
                      Icons.info,
                      color: pinkRozoomColor,
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Hero(
                tag: trainingId,
                child: Image.network(
                  trainingImageUrl,
                  fit: BoxFit.contain,
                  height: defaultSize * 25, //378
                  width: defaultSize * 35,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Material(
                  child: RaisedButton(
                    elevation: 1.5,
                    padding: EdgeInsets.all(defaultSize * 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: blueRozoomColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          TrainingProcessScreen.routeName,
                          arguments: {
                            'trainingId': trainingId,
                          });
                    },
                    child: Text(
                      "Почати",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: defaultSize * 1.6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
