import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PageController _pageController = PageController(
    initialPage: 1,
  );
  int currentIndex = 1;

  _onLoad() {
    Widget(BuildContext context) {
      return Scaffold(
        body: SpinKitCircle(
          color: Colors.white,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.grey,
            ),
            onPressed: null),
        title: Center(
            child: SvgPicture.asset(
          'assets/images/profile/brand.svg',
          height: 35,
        )),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            currentIndex = page;
          });
        },
        children: <Widget>[
          Text('Left page!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'),
          SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, right: 5, left: 5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    RawMaterialButton(
                                        child: Icon(
                                          Icons.grade,
                                          color: Colors.grey[300],
                                        ),
                                        elevation: 2.0,
                                        fillColor: Colors.white,
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 1,
                                                color: Colors.grey[200])),
                                        onPressed: null),
                                    Positioned(
                                      top: 35,
                                      left: 60,
                                      child: SizedBox(
                                        // height: 10,
                                        // width: 10,
                                        child: Text(
                                          '80',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 130,
                                          width: 130,
                                          child: Image.network(
                                              'https://rozoom.com.ua/avatars/antonio-pina-fpXAZuqJJAw-unsplash.jpg'),
                                          //   child: Image.network(
                                          //       'https://rozoom.co.ua/uploads/avatars/DCBU5wZmmuwU7lJLhDMtXGg3xpXc4qkThGKEAYkE.png'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    RawMaterialButton(
                                        child: Icon(
                                          Icons.chat,
                                          color: Colors.grey[300],
                                        ),
                                        elevation: 2.0,
                                        fillColor: Colors.white,
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 1,
                                                color: Colors.grey[200])),
                                        onPressed: null),
                                    Positioned(
                                      top: 35,
                                      left: 60,
                                      child: SizedBox(
                                        // height: 10,
                                        // width: 10,
                                        child: Text(
                                          '10+',
                                          style: TextStyle(color: Colors.pink),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Ім'я",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Divider(),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'E-mail',
                                // '_email',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                            // Divider(),
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'баланс',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '0.00 грн',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Розкрити більше інформаціі',
                                    // context.watch<Data>().getData,
                                    style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[300],
                                  ),
                                  onPressed: null),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {},
                            elevation: 3,
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/profile/01.png',
                              fit: BoxFit.fill,
                              scale: 1.55,
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {},
                            elevation: 3,
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/profile/02.png',
                              fit: BoxFit.fill,
                              scale: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {},
                            elevation: 3,
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/profile/03.png',
                              fit: BoxFit.fill,
                              scale: 1.55,
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {},
                            elevation: 3,
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/profile/04.png',
                              fit: BoxFit.fill,
                              scale: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/profile/11.png',
                            fit: BoxFit.fill,
                            scale: 3,
                          ),
                          Image.asset(
                            'assets/images/profile/12.png',
                            fit: BoxFit.fill,
                            scale: 3,
                          ),
                          Image.asset(
                            'assets/images/profile/13.png',
                            fit: BoxFit.fill,
                            scale: 3,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/profile/31.png',
                            fit: BoxFit.fill,
                            scale: 1.3,
                          ),
                          Image.asset(
                            'assets/images/profile/32.png',
                            fit: BoxFit.fill,
                            scale: 1.3,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/profile/33.png',
                            fit: BoxFit.fill,
                            scale: 1.3,
                          ),
                          Image.asset(
                            'assets/images/profile/34.png',
                            fit: BoxFit.fill,
                            scale: 1.3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Color(0xFF74bec9),
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          currentIndex = value;
          // switch (value) {
          //   case 0:
          //     Navigator.pushNamed(context, '/left', arguments: userdata);
          //     break;
          //   case 1:
          //     Navigator.pushNamed(context, '/profile', arguments: userdata);
          //     break;
          //   case 2:
          //     Navigator.pushNamed(context, '/right', arguments: userdata);
          //     break;
          // }
          _pageController.animateToPage(
            value,
            duration: Duration(milliseconds: 400),
            curve: Curves.linear,
          );
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Кабинет')),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('Учеба')),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), title: Text('Друзья')),
        ],
      ),
    );
  }
}
