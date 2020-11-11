import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/models/http_exception.dart';
import 'package:rozoom_app/core/providers/auth_provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/core/providers/training_provider.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/app_bar.dart';
import 'package:rozoom_app/ui/training_screens/widgets/trainings_item.dart';

enum FilterOptions {
  EditProfile,
  Logout,
}

class TrainingsOverviewScreen extends StatefulWidget {
  static const routeName = '/training-themes-overview';

  @override
  _TrainingsOverviewScreenState createState() =>
      _TrainingsOverviewScreenState();
}

class _TrainingsOverviewScreenState extends State<TrainingsOverviewScreen> {
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<TrainingThemes>(context, listen: false)
        .fetchAndSetTrainingThemes()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    final trainThemes =
        Provider.of<TrainingThemes>(context).trainingThemesItems;
    // print('train themes ----- $trainThemes');

    return Scaffold(
      appBar: myAppBar(context),
      body: _isLoading
          ? Center(child: Image.asset("assets/gifs/ripple.gif"))
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(defaultSize * 2), //20
                child: GridView.builder(
                  // We just turn off grid view scrolling
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // just for demo
                  itemCount: trainThemes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        SizeConfig.orientation == Orientation.portrait ? 2 : 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) => TrainingsItem(
                      trainThemes[index].id,
                      trainThemes[index].name,
                      trainThemes[index].imageUrl),
                ),
              ),
            ),
    );
  }

  getUserProfile() async {
    try {
      await Provider.of<Profile>(context, listen: false).getProfileInfo();
    } on HttpException catch (error) {
      var errorMessage = error.toString();

      _showErrorDialog(errorMessage);

      return;
    } catch (error) {}
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ОК',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
