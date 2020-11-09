import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/size_config.dart';

AppBar myAppBar(BuildContext context, String route, String title,
    String balance, String certificates, bool popOnBack, bool showLeading) {
  return AppBar(
    automaticallyImplyLeading: showLeading,
    elevation: 1,
    backgroundColor: Colors.white,
    leading: showLeading
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: () {
              popOnBack
                  ? Navigator.of(context).pop()
                  : showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 3, color: Color(0xFFf06388)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        title: Text(
                          'Завершити проходження?',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Так',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(route);

                              // Provider.of<Task>(context, listen: false).nullTaskData();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Ні',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    );
            })
        : null,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(width: 35),
            Image.asset(
              'assets/images/stats/coin.png',
              scale: 0.55,
            ),
            SizedBox(width: 5),
            balance != null
                ? Text(balance,
                    style: TextStyle(color: Colors.black, fontSize: 16))
                : Text(''),
            SizedBox(width: 10),
            Image.asset('assets/images/stats/uah.png',
                height: SizeConfig.defaultSize * 3.0),
            SizedBox(width: 5),
            certificates != null
                ? Text(certificates,
                    style: TextStyle(color: Colors.black, fontSize: 16))
                : Text(''),
          ],
        ),
      ],
    ),
    actions: <Widget>[
      Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
    ],
  );
}

void _showExitDialog(String message) {}
