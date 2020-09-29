import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:rozoom_app/api/api.dart';
import 'package:rozoom_app/models/Provider.dart';
import 'package:rozoom_app/providers/auth_token_provider.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';

class Auth extends StatefulWidget {
  Auth({Key key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _isLoggedIn = false;
  bool _isInAsyncCall = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  Future<void> authenticate() async {
    final String url = 'https://rozoom.com.ua/api/mobile/';
    try {
      setState(() {
        _isInAsyncCall = true;
      });
      final _googleResponse = await _googleSignIn.signIn();
      print('01 - googleResponse -----------------> $_googleResponse');
      final _googleKey = await _googleResponse.authentication;
      print('02 - googleKey -----------------> $_googleKey');
      final _googleAccessToken = _googleKey.accessToken;
      print('03 - _googleAccessToken -----------------> $_googleAccessToken');

      final response = await http
          .post('${url}auth/google?token=$_googleAccessToken&type_id=1');
      final _googleData = json.decode(response.body) as Map<String, dynamic>;
      print('04 - _googleData response -----------------> $_googleData');
      final _rozoomToken = _googleData['api_token'].toString();
      print('05 - _rozoomToken -----------------> $_rozoomToken');

      final _isParent = _googleData['user']['is_parent'];
      print('05.5 - _isParent -----------------> $_isParent');
      print('05.5 - _isParent -----------------> ${_isParent.runtimeType}');
      if (_isParent != 0) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            // shape: ShapeBorder(),
            title: Text('Цей email зареєстрований на батьківський акаунт!'),
            content: Text('Спробуй інший.'),
            actions: <Widget>[
              FlatButton(
                child: Text('ОК'),
                onPressed: () {
                  setState(() {
                    Navigator.pushReplacementNamed(context, '/auth');
                  });
                },
              )
            ],
          ),
        );
        return;
      }

      Provider.of<TokenData>(context, listen: false)
          .changeTokenData(_rozoomToken);
      print(
          '06 - TokenData -----------------> ${Provider.of<TokenData>(context, listen: false).getTokenData}');
      Provider.of<AuthToken>(context, listen: false)
          .changeAuthToken(_rozoomToken);
      print(
          '07 - AuthToken -----------------> ${Provider.of<AuthToken>(context, listen: false).getAuthToken}');
      Provider.of<Pusher>(context, listen: false)
          .changeRozoomToken(_rozoomToken);
      print(
          '08 - PusherToken -----------------> ${Provider.of<Pusher>(context, listen: false).getRozoomToken}');

      final rozoomResponse =
          await http.post('${url}me?api_token=$_rozoomToken');
      final _rozoomData =
          json.decode(rozoomResponse.body) as Map<String, dynamic>;
      print('09 - _rozoomData response -----------------> $_rozoomData');

      final myId = _rozoomData['user']['id'].toString();
      context.read<MyId>().changeData(myId);

      setState(() {
        _isLoggedIn = true;
        _isInAsyncCall = false;

        Navigator.pushNamed(context, '/home');
      });
    } catch (error) {
      print('error -------------> $error');
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Щось пішло не так!'),
          content: Text('Спробуйте ще раз.'),
          actions: <Widget>[
            FlatButton(
              child: Text('ОК'),
              onPressed: () {
                setState(() {
                  Navigator.pushReplacementNamed(context, '/auth');
                });
              },
            )
          ],
        ),
      );
    }
  }

  Future<void> _logout() async {
    await _googleSignIn.signOut();
    context.read<TokenData>().changeTokenData('Token Data droped');
    setState(() {
      _isInAsyncCall = false;
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
            child: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          // demo of some additional parameters
          // opacity: 0.5,
          // dismissible: true,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[300]),
            backgroundColor: Colors.pink[200],
            strokeWidth: 10,
            // value: 0.2,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset('assets/images/mainlogo.png'),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: GoogleSignInButton(
                      // child: Text("Login with Google"),
                      onPressed: () {
                        authenticate();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Image(
                    image: AssetImage('assets/images/brand.png'),
                    width: 200,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _logout();
                  },
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
