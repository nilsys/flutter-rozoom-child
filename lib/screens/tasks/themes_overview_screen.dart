import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/widgets/tasks/discipline_item.dart';
import 'package:rozoom_app/widgets/tasks/theme_item.dart';

class ThemesOverviewScreen extends StatefulWidget {
  static const routeName = '/themes-overview';

  @override
  _ThemesOverviewScreenState createState() => _ThemesOverviewScreenState();
}

class _ThemesOverviewScreenState extends State<ThemesOverviewScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final int disciplineId = args['disciplineId'];
      Provider.of<Themes>(context, listen: false)
          .fetchandSetThemes(disciplineId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String disciplineTitleUa = args['disciplineTitleUa'];
    final themes = Provider.of<Themes>(context).themeItems;
    return Scaffold(
      backgroundColor: Color(0XFFFEF9EB),
      // backgroundColor: Color(0Xf8f9fa),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Provider.of<Themes>(context, listen: false).nullThemeImages();
              Navigator.pop(context);
            }),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              disciplineTitleUa.length > 10
                  ? '${disciplineTitleUa.replaceRange(10, disciplineTitleUa.length, '...')}'
                  : '$disciplineTitleUa',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/coin.svg',
                  height: 30,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '364.60',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  'assets/images/uah.svg',
                  height: 40,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '9',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: themes.length,
        itemBuilder: (ctx, i) => ThemeItem(
          themes[i].id,
          themes[i].name,
          themes[i].imageUrl,
          themes[i].klass,
          themes[i].tasksCount,
        ),
      ),
    );
  }
}
