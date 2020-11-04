import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/http_exception.dart';
import 'package:rozoom_app/providers/auth_provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/training_provider.dart';
import 'package:rozoom_app/size_config.dart';
import 'package:rozoom_app/widgets/components/app_bar.dart';
import 'package:rozoom_app/widgets/trainings/trainings_item.dart';

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
  List<TrainingThemeModel> _trainingThemesItems = [
    TrainingThemeModel(
        id: '1',
        name: 'Лічба в межах 30',
        imageUrl: 'https://rozoom.com.ua/images/training/1.png'),
    TrainingThemeModel(
        id: '3',
        name: 'Порівняння чисел в межах 100',
        imageUrl: 'https://rozoom.com.ua/images/training/3.png'),
    TrainingThemeModel(
        id: '4',
        name: 'Додавання і віднімання в межах 10 - 100',
        imageUrl: 'https://rozoom.com.ua/images/training/4.png'),
    TrainingThemeModel(
        id: '5',
        name: 'Лічба в межах 30',
        imageUrl: 'https://rozoom.com.ua/images/training/1.png'),
    TrainingThemeModel(
        id: '6',
        name: 'Порівняння чисел в межах 100',
        imageUrl: 'https://rozoom.com.ua/images/training/3.png'),
    TrainingThemeModel(
        id: '7',
        name: 'Додавання і віднімання в межах 10 - 100',
        imageUrl: 'https://rozoom.com.ua/images/training/4.png'),
    TrainingThemeModel(
        id: '8',
        name: 'Лічба в межах 30',
        imageUrl: 'https://rozoom.com.ua/images/training/1.png'),
    TrainingThemeModel(
        id: '9',
        name: 'Порівняння чисел в межах 100',
        imageUrl: 'https://rozoom.com.ua/images/training/3.png'),
    TrainingThemeModel(
        id: '10',
        name: 'Додавання і віднімання в межах 10 - 100',
        imageUrl: 'https://rozoom.com.ua/images/training/4.png'),
  ];

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
      appBar: myAppBar(context, 'Тренажери', '111', '5'),
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
                  itemCount: _trainingThemesItems.length,
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
