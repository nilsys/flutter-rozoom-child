import 'package:flutter/material.dart';

class ThemesOverviewScreen extends StatelessWidget {
  static const routeName = '/themes-overview';

  @override
  Widget build(BuildContext context) {
    final disiplineTitle = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        //   onPressed: null,
        // ),
        title: Text('$disiplineTitle / Теми'),
      ),
      body: null,
    );
  }
}
