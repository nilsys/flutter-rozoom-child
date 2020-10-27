import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/rozoom_item.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/edit_profile_screen.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/widgets/fade-animation.dart';
import 'package:rozoom_app/widgets/profile/user_image_picker.dart';
import 'package:rozoom_app/widgets/profile/username_form.dart';
import 'package:rozoom_app/widgets/tasks/discipline_item.dart';

enum FilterOptions {
  EditProfile,
  Logout,
}

class IndexScreen extends StatefulWidget {
  static const routeName = '/index';

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final List<String> _listItem = [
    'assets/images/index/01.png',
    'assets/images/index/02.png',
    'assets/images/index/03.png',
    'assets/images/index/04.png',
    'assets/images/index/11.png',
    'assets/images/index/12.png',
    'assets/images/index/13.png',
    'assets/images/index/21.png',
    'assets/images/index/22.png',
    'assets/images/index/23.png',
    'assets/images/index/24.png',
  ];
  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final avatar = Provider.of<Profile>(context, listen: false).avatarUrl;
    final name = Provider.of<Profile>(context, listen: false).name;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading: Icon(
        //   Icons.ac_unit,
        //   color: Colors.white,
        // ),
        elevation: 1,
        backgroundColor: Colors.white,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.EditProfile) {
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                  // _showOnlyFavorites = true;
                } else {
                  // _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Профайл'),
                value: FilterOptions.EditProfile,
              ),
              PopupMenuItem(
                child: Text('Вийти'),
                value: FilterOptions.Logout,
              ),
            ],
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset('assets/images/logo.png',
                // height: 30,
                width: 100
                // scale: 0.1,
                ),
            Consumer<Profile>(
              builder: (ctx, profile, child) => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Text(
                  //   'Дісципліни',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  SizedBox(
                    width: 35,
                  ),
                  Image.asset(
                    'assets/images/stats/coin.png',
                    // height: 300,
                    scale: 0.55,
                    // width: 50,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    profile.balance,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/images/stats/uah.png',
                    height: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    profile.certificates,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        gradient:
                            LinearGradient(begin: Alignment.topLeft, colors: [
                          Color(0xff39749a).withOpacity(.9),
                          Color(0xff39749a).withOpacity(.2),
                        ])),
                    // height: 200,

                    // alignment: Alignment.center,
                    // color: Theme.of(context).primaryColor,
                    child: Image.asset(
                      'assets/images/index/bg.png', fit: BoxFit.fill,
                      // scale: 1.5,
                    ),
                  ),
                  // Positioned(
                  //   right: 10,
                  //   bottom: 10,
                  //   child: Container(
                  //     height: 100,
                  //     // alignment: Alignment.center,
                  //     // color: Theme.of(context).primaryColor,
                  //     child: Image.asset(
                  //       'assets/images/brand.png', fit: BoxFit.fill,
                  //       // scale: 1.5,
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        2.6,
                        Text(
                          "Навчання",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                              fontSize: 20),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        2.8,
                        Container(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              makeItem(
                                image: 'assets/images/index/01.png',
                                title: 'Завдання',
                                path: '/disciplines-overview',
                              ),
                              makeItem(
                                  image: 'assets/images/index/02.png',
                                  title: 'Тренажери'),
                              makeItem(
                                  image: 'assets/images/index/03.png',
                                  title: 'RoZoom - ринг'),
                              makeItem(
                                  image: 'assets/images/index/04.png',
                                  title: 'Виправлення помилок')
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        3,
                        Text(
                          "Кошик",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                              fontSize: 20),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        3.2,
                        Container(
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              makeItem(
                                  image: 'assets/images/index/11.png',
                                  title: 'МоЇ нагороди'),
                              makeItem(
                                  image: 'assets/images/index/12.png',
                                  title: 'МоЇ картки'),
                              makeItem(
                                  image: 'assets/images/index/13.png',
                                  title: 'МоЇ гроші'),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        3.4,
                        Text(
                          "Додатки",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                              fontSize: 20),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        3.6,
                        Container(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              makeItem(
                                  image: 'assets/images/index/21.png',
                                  title: 'Цілі'),
                              makeItem(
                                  image: 'assets/images/index/22.png',
                                  title: 'Магазин'),
                              makeItem(
                                  image: 'assets/images/index/23.png',
                                  title: 'Уроки від вчителя'),
                              makeItem(
                                  image: 'assets/images/index/24.png',
                                  title: 'Відео ролики'),
                              makeItem(
                                  image: 'assets/images/index/25.png',
                                  title: 'ЗНО')
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeItem({image, title, path}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(path);
      },
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          elevation: 1.5,
          child: Container(
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey[300], width: 1),
              // borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(image),
                // fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 18.0,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      // gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                      // Theme.of(context).primaryColor.withOpacity(.6),
                      // Theme.of(context).primaryColor.withOpacity(.1),
                      // ])
                      ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    // child: Text(
                    //   title,
                    //   style: TextStyle(
                    //       color: Theme.of(context).primaryColor, fontSize: 20),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
