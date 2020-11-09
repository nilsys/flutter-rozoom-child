import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/widgets/fade-animation.dart';

enum FilterOptions {
  EditProfile,
  Logout,
}

class HomeChild extends StatefulWidget {
  @override
  _HomeChildState createState() => _HomeChildState();
}

class _HomeChildState extends State<HomeChild> {
  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  child: Image.asset(
                    'assets/images/index/bg.png', fit: BoxFit.fill,
                    // scale: 1.5,
                  ),
                ),
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
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
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
                                path: '/disciplines-overview'),
                            makeItem(
                              image: 'assets/images/index/02.png',
                              title: 'Тренажери',
                              path: '/training-themes-overview',
                            ),
                            makeItem(
                                image: 'assets/images/index/03.png',
                                title: 'RoZoom - ринг'),
                            makeItem(
                                image: 'assets/images/index/04.png',
                                title: 'Виправлення помилок',
                                path: '/fix-task'),
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
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
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
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
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
    );
  }

  Widget makeItem({image, title, String path}) {
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
                        color: Colors.grey[800],
                        // fontFamily: 'bip',
                        fontSize: 17,
                        // fontWeight: FontWeight.bold,
                      ),
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
