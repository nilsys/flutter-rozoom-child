import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/models/http_exception.dart';
import 'package:rozoom_app/core/providers/achievements_provider.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/dialogs.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';

class CardsScreen extends StatelessWidget {
    static const routeName = '/cards';

    Future<void> _loadCards(context) async {
    try {
      await Provider.of<Achievments>(context, listen: false)
          .apiGetCards();
    } on HttpException catch (error) {
      print(error);
      MyDialogs().showApiErrorDialog(context, error.toString());
    } catch (error) {
      MyDialogs().showUnknownErrorDialog(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    _loadCards(context);
    return Consumer<Achievments>(
      builder: (context, achiev, child) => achiev.isLoadingScreen
          ? MyLoaderScreen()
          :Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 168.0),
              child: SelectableText(achiev.apiToString),
            ),
            ),
          ),
      ),
    );
  }
}