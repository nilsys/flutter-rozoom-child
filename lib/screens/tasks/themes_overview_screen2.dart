import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/widgets/tasks/theme_item2.dart';

class ThemesOverviewScreen2 extends StatefulWidget {
  static const routeName = '/themes-overview2';

  @override
  _ThemesOverviewScreen2State createState() => _ThemesOverviewScreen2State();
}

class _ThemesOverviewScreen2State extends State<ThemesOverviewScreen2> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((_) {
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final int disciplineId = args['disciplineId'];
      Provider.of<Themes>(context, listen: false)
          .fetchandSetThemes(disciplineId);
    }).then((_) => setState(() {
          _isLoading = false;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String disciplineTitleUa = args['disciplineTitleUa'];
    final themes = Provider.of<Themes>(context).themeItems;
    return Scaffold(
      // backgroundColor: Color(0XFFFEF9EB),
      // backgroundColor: Color(0Xf8f9fa),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
            Provider.of<Themes>(context, listen: false).nullThemeImages();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            onPressed: () {
              // Navigator.pop(context);
            },
          ),
        ],
        title: _isLoading
            ? Text('')
            : Consumer<Profile>(
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
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Color(0xFF74bec9),
                    ),
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                  ),
                  Text(
                    '/ ',
                    style: TextStyle(color: Color(0xFF74bec9), fontSize: 16),
                  ),
                  Text(
                    disciplineTitleUa,
                    style: TextStyle(color: Color(0xFF74bec9), fontSize: 16),
                  ),
                  Text(
                    ' / ',
                    style: TextStyle(color: Color(0xFF74bec9), fontSize: 16),
                  ),
                  Text(
                    'Оберіть тему',
                    style: TextStyle(color: Color(0xFF74bec9), fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return ThemeItem2(
                  themes[i].id,
                  themes[i].name,
                  themes[i].imageUrl,
                  themes[i].klass,
                  themes[i].tasksCount,
                );
              },
              itemCount: themes.length,
            ),
          ),
        ],
      ),
    );
  }
}
