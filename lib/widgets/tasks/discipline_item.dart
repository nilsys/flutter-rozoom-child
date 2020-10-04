import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rozoom_app/screens/tasks/disciplines_overview_screen.dart';
import 'package:rozoom_app/screens/tasks/themes_overview_screen.dart';

class DisciplineItem extends StatelessWidget {
  final int id;
  final String titleUa;
  final String imageUrl;
  DisciplineItem(this.id, this.titleUa, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ThemesOverviewScreen.routeName, arguments: titleUa);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        elevation: 1,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
                child: SvgPicture.network(
                  imageUrl,
                  placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator(
                        strokeWidth: 1,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                titleUa,
                style: TextStyle(
                  color: Color(0xFF74bec9),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
