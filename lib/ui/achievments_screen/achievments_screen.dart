import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/models/http_exception.dart';
import 'package:rozoom_app/core/providers/achivments_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/error_dialog.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';

class AchievmentsScreen extends StatelessWidget {
  Future<void> _loadAchievments(context) async {
    try {
      await Provider.of<Achievments>(context, listen: false)
          .apiGetAchievments();
    } on HttpException catch (error) {
      print(error);
      // MyDialogs().showApiErrorDialog(context, error.toString());
    } catch (error) {
      MyDialogs().showUnknownErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    _loadAchievments(context);
    return Consumer<Achievments>(
      builder: (context, achiev, _) => achiev.isLoading
          ? MyLoaderScreen()
          : Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: defaultSize * 3),

                          // padding: EdgeInsets.all(18),
                          child: Center(
                            child: Text(
                              'Мої нагороди',
                              style: TextStyle(
                                  fontSize: defaultSize * 2.2,
                                  color: blueRozoomColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Container(
                          // margin: EdgeInsets.only(top: defaultSize),
                          child: ListView.builder(
                        // scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: achiev.achievCategoriesItems.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.all(defaultSize * 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: defaultSize * 5,
                                  right: defaultSize * 5,
                                ),
                                child: Divider(
                                  color: pinkRozoomColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: defaultSize, top: defaultSize),
                                child: Text(
                                  achiev.achievCategoriesItems[index].name,
                                  style: TextStyle(
                                      fontSize: defaultSize * 2,
                                      color: pinkRozoomColor),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: defaultSize * 5,
                                    right: defaultSize * 5,
                                    bottom: defaultSize * 2),
                                child: Divider(
                                  color: pinkRozoomColor,
                                ),
                              ),
                              GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: SizeConfig.orientation ==
                                          Orientation.portrait
                                      ? 2
                                      : 4,
                                  mainAxisSpacing: defaultSize,
                                  crossAxisSpacing: defaultSize,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, i) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: defaultSize * 10,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                achiev
                                                    .achievWithCat(index)[i]
                                                    .imageUrl,
                                              ),
                                              fit: BoxFit.contain,
                                            ),
                                            // border: Border.all(
                                            //   color: Colors.black,
                                            //   width: 8,
                                            // ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        Positioned.fill(
                                          bottom: defaultSize * 2,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              achiev
                                                  .achievWithCat(index)[i]
                                                  .price,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: defaultSize * 2.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(defaultSize * 0.5),
                                      child: Text(
                                        achiev
                                            .achievWithCat(index)[i]
                                            .description,
                                        style: TextStyle(
                                            fontSize: defaultSize * 1.4),
                                      ),
                                    ),
                                    Container(
                                      width: defaultSize * 14,
                                      height: defaultSize * 3,
                                      child: RaisedButton(
                                          elevation: 0,
                                          onPressed: () {},
                                          color: Colors.white,
                                          textColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.green)),
                                          child: Icon(Icons.check)),
                                    )
                                  ],
                                ),
                                itemCount:
                                    achiev.achievWithCat(index).toList().length,
                              )
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
