import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/Provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewWebPage(),
    );
  }
}

class WebViewWebPage extends StatefulWidget {
  @override
  _WebViewWebPageState createState() => _WebViewWebPageState();
}

class _WebViewWebPageState extends State<WebViewWebPage> {
  Future<bool> _onBack() async {
    bool goBack;

    var value = await webView.canGoBack(); // check webview can go back

    if (value) {
      webView.goBack(); // perform webview back operation

      return false;
    } else {
      await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Вихід ', style: TextStyle(color: Colors.purple)),

          // Are you sure?

          content: new Text('Бажаєте вийти? '),

          // Do you want to go back?

          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);

                setState(() {
                  goBack = false;
                });
              },

              child: new Text('Ні'), // No
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  goBack = true;
                });
              },

              child: new Text('Так'), // Yes
            ),
          ],
        ),
      );

      if (goBack) Navigator.pop(context); // If user press Yes pop the page

      return goBack;
    }
  }

  // URL to load

  var LISTENINGURL = "https://www.linkedin.com/in/omeryilmaz86/";

  // Webview progress

  double progress = 0;

  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    final _token = context.watch<TokenData>().getTokenData;
    var URL = "https://rozoom.co.ua/redirect/dashboard?api_token=$_token";
    return WillPopScope(
      onWillPop: _onBack,
      child: SafeArea(
        child: Scaffold(
            body: Container(
                child: Column(
                    children: <Widget>[
          (progress != 1.0)
              ? LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink))
              : null, // Should be removed while showing

          Expanded(
            child: Container(
              child: InAppWebView(
                initialUrl: URL,

                initialHeaders: {},

                //  initialOptions: {},

                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },

                onLoadStart: (InAppWebViewController controller, String url) {
                  // Listen Url change

                  if (URL == LISTENINGURL) {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => new SecondPage()));
                  }
                },

                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          )
        ].where((Object o) => o != null).toList()))),
      ),
    ); //Remove null widgets
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Page"),
      ),
      body: Container(
        child: Center(
          child: Text("Hey,there!"),
        ),
      ),
    );
  }
}
