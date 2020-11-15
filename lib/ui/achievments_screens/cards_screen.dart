import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/models/http_exception.dart';
import 'package:rozoom_app/core/providers/achievements_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/dialogs.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';
import 'package:rozoom_app/shared/widgets/loader_widget.dart';

class CardsScreen extends StatelessWidget {
  static const routeName = '/cards';

  Future<void> _loadCards(context) async {
    try {
      await Provider.of<Achievments>(context, listen: false).apiGetCards();
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
      builder: (context, cards, child) => cards.isLoadingScreen
          ? MyLoaderScreen()
          : Scaffold(
              body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(defaultSize),
                        margin: EdgeInsets.only(
                            top: defaultSize * 3,
                            left: defaultSize * 1,
                            right: defaultSize * 1),
                        child: Card(
                          elevation: 1,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: defaultSize,
                                ),
                                child: Text(
                                  'Мої картки',
                                  style: TextStyle(
                                      fontSize: defaultSize * 3,
                                      color: pinkRozoomColor),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: defaultSize * 3),
                                  child: Divider(
                                    color: blueRozoomColor,
                                    height: 3,
                                  )),
                              Padding(
                                padding: EdgeInsets.all(defaultSize),
                                child: Text(
                                  '   Тепер Ви щодня можете обмінювати свої картки на гривні. Ці гривні можна витратити в магазині порталу.',
                                  style: TextStyle(
                                      fontSize: defaultSize * 1.8,
                                      color: Colors.black.withOpacity(0.8)),
                                  // textAlign: TextAlign.center,
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.all(defaultSize),
                              //   child: Text(
                              //     '   Звичайно ж заробити на цілий телефон або планшет - не легко, і потрібен не один місяць праці, але ж точно так же кожен день для нас трудяться наші Мами і Папи. Так давайте їм допоможемо?',
                              //     style: TextStyle(fontSize: defaultSize * 1.8),
                              //     // textAlign: TextAlign.center,
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.all(defaultSize),
                                child: Text(
                                  '   Пам\'ятайте: виконуючи тести і тренажери ви стаєте розумнішими, і це також радує Батьків. Успіхів!',
                                  style: TextStyle(
                                      fontSize: defaultSize * 1.8,
                                      color: Colors.black.withOpacity(0.8)),
                                  // textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                      // color: blueRozoomColor,
                      margin: EdgeInsets.only(
                          top: defaultSize,
                          left: defaultSize * 1,
                          right: defaultSize * 1,
                          bottom: defaultSize * 5),
                      child: Container(
                        // color: pinkRozoomColor,
                        padding: EdgeInsets.all(defaultSize * 1),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                SizeConfig.orientation == Orientation.portrait
                                    ? 2
                                    : 4,
                            mainAxisSpacing: defaultSize * 1,
                            crossAxisSpacing: defaultSize * 1,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, i) => CardItem(
                              title: cards.cardItems[i].title,
                              description: cards.cardItems[i].description,
                              count: cards.cardItems[i].count,
                              imageUrl: cards.cardItems[i].imageUrl),
                          itemCount: cards.cardItems.length,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String description;
  final String count;
  final String imageUrl;
  CardItem({this.title, this.description, this.count, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: defaultSize * 13,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: myLoaderWidget());
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(defaultSize * 0.5),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: defaultSize * 1.4),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Tooltip(
                    // height: 100,
                    decoration: BoxDecoration(
                        color: pinkRozoomColor, shape: BoxShape.rectangle),
                    padding: EdgeInsets.all(defaultSize),
                    margin: EdgeInsets.symmetric(horizontal: defaultSize * 5),
                    message: description,
                    child: Icon(
                      Icons.info,
                      color: pinkRozoomColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
