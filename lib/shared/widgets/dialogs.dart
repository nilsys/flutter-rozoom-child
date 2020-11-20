import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/auth_provider.dart';
import 'package:rozoom_app/shared/size_config.dart';

class MyDialogs {
  showTokenErrorDialog(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          'Час сесії вичерпано!',
          style: TextStyle(color: Colors.white, fontSize: defaultSize * 1.8),
        ),
        content: Text(
          'Будь ласка, авторизуйся!',
          style: TextStyle(color: Colors.white, fontSize: defaultSize * 2),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ОК',
              style: TextStyle(color: Colors.white, fontSize: defaultSize * 2),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

  showApiErrorDialog(BuildContext context, message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ОК',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

  showUnknownErrorDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          'Помилка!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Щось пішло не так. Обновити сессію?',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Так',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
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
          ),
        ],
      ),
    );
  }

  showOkDialog(BuildContext context, String message) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ви отримали',
              style: TextStyle(color: Colors.white, fontSize: defaultSize * 2),
            ),
            SizedBox(width: defaultSize * 0.5),
            Text(message,
                style:
                    TextStyle(color: Colors.white, fontSize: defaultSize * 2)),
            SizedBox(width: defaultSize * 0.5),
            Image.asset('assets/images/stats/coin.png', scale: 0.55),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ОК',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  showCardToolTipDialog(BuildContext context, String message) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                right: defaultSize, left: defaultSize, bottom: defaultSize * 2),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: defaultSize * 2),
            ),
          ),
        ),
        actions: <Widget>[],
      ),
    );
  }
}
