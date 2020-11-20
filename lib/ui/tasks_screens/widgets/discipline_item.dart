import 'package:flutter/material.dart';

import 'package:rozoom_app/ui/tasks_screens/themes_overview_screen.dart';

class DisciplineItem extends StatelessWidget {
  final String id;
  final String titleUa;
  final String imageUrl;
  DisciplineItem(this.id, this.titleUa, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ThemesOverviewScreen.routeName,
            arguments: {'disciplineId': id, 'disciplineTitleUa': titleUa});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        elevation: 1.5,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
                // child: Image.asset(
                //   'imageUrl',
                //   errorBuilder: (BuildContext context, Object exception,
                //       StackTrace stackTrace) {
                //     return Image.asset('assets/images/brand.png');
                //   },
                // ),

                child: Image.asset(
                  imageUrl,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Text(
                  titleUa,
                  style: TextStyle(
                    color: Color(0xFF74bec9),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
