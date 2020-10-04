import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/Provider.dart';
import 'package:rozoom_app/models/http_exception.dart';
import 'package:rozoom_app/providers/auth_token_provider.dart';
import 'package:rozoom_app/providers/pusher_provider.dart';
import 'package:rozoom_app/providers/video_chat_provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Image.asset('assets/images/mainlogo.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _loginController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Помилка!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('ОК'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await signup(
          _authData['email'],
          _authData['username'],
          _authData['password'],
        );
        // Navigator.pushNamed(context, '/home');
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      // const errorMessage =
      //     'Could not authenticate you. Please try again later.';
      // _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
        _loginController.clear();
        _usernameController.clear();
        _passwordController.clear();
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _loginController.clear();
        _usernameController.clear();
        _passwordController.clear();
      });
      _controller.reverse();
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<void> login(email, password) async {
    final String url =
        'https://rozoom.com.ua/api/mobile/auth?login=$email&password=$password';

    final response = await http.post(url);
    final _apiData = json.decode(response.body) as Map<String, dynamic>;
    print('01 --- ApiData --------------> $_apiData');
    final _token = _apiData['api_token'];

    Provider.of<TokenData>(context, listen: false).changeTokenData(_token);
    print(
        '02 - TokenData -----------------> ${Provider.of<TokenData>(context, listen: false).getTokenData}');
    Provider.of<AuthToken>(context, listen: false).changeAuthToken(_token);
    print(
        '03 - AuthToken -----------------> ${Provider.of<AuthToken>(context, listen: false).getAuthToken}');
    Provider.of<Pusher>(context, listen: false).changeRozoomToken(_token);
    print(
        '04 - PusherToken -----------------> ${Provider.of<Pusher>(context, listen: false).getRozoomToken}');

    // Provider.of<VideoChat>(context, listen: false).setAuthToken(_token);

    var errorMessage = '';
    print('${_apiData['result']}');
    print('${_apiData['result'].runtimeType}');
    if (_apiData['result'] == false) {
      errorMessage = 'Щось пішло не так. Спробуйте ще.';
      _showErrorDialog(errorMessage);
    }
    if (_apiData['exists'] == false) {
      errorMessage = 'Користувача с таким логіном не існує';
      _showErrorDialog(errorMessage);
    }
    if (_apiData['exists'] == true && _apiData['authenticated'] == false) {
      errorMessage = 'Невірний пароль';
      _showErrorDialog(errorMessage);
    }

    print('${_apiData['user']['is_parent']}');
    print('${_apiData['user']['is_parent'].runtimeType}');
    if (_apiData['user']['is_parent'] != 0) {
      errorMessage = 'Цей логін вже зареєстрований на батьківський акаунт!';
      _showErrorDialog(errorMessage);
    }
    if (_apiData['exists'] == true &&
        _apiData['authenticated'] == true &&
        _apiData['user']['is_parent'] == 0) {
      setState(() {
        _isLoading = true;
        Navigator.pushNamed(context, '/home');
      });
    }
  }

  Future<void> signup(email, username, password) async {
    final String url =
        'https://rozoom.com.ua/api/mobile/auth?login=$email&password=$password&name=$username&type_id=1';
    print(url);

    final response = await http.post(url);
    final _apiData = json.decode(response.body) as Map<String, dynamic>;
    print('01 --- ApiData --------------> $_apiData');
    final _token = _apiData['api_token'];
    Provider.of<TokenData>(context, listen: false).changeTokenData(_token);
    print(
        '02 - TokenData -----------------> ${Provider.of<TokenData>(context, listen: false).getTokenData}');
    Provider.of<AuthToken>(context, listen: false).changeAuthToken(_token);
    print(
        '03 - AuthToken -----------------> ${Provider.of<AuthToken>(context, listen: false).getAuthToken}');
    Provider.of<Pusher>(context, listen: false).changeRozoomToken(_token);
    print(
        '04 - PusherToken -----------------> ${Provider.of<Pusher>(context, listen: false).getRozoomToken}');

    var errorMessage = '';
    print('${_apiData['result']}');
    print('${_apiData['result'].runtimeType}');
    if (_apiData['result'] == false) {
      errorMessage = 'Щось пішло не так. Спробуйте ще.';
      _showErrorDialog(errorMessage);
    }
    if (_apiData['exists'] == true) {
      errorMessage = 'Користувач с таким логіном вже існує';
      _showErrorDialog(errorMessage);
    }
    // if (_apiData['exists'] == true && _apiData['authenticated'] == false) {
    //   errorMessage = 'Невірний пароль';
    //   _showErrorDialog(errorMessage);
    // }

    print('${_apiData['user']['is_parent']}');
    print('${_apiData['user']['is_parent'].runtimeType}');
    // if (_apiData['user']['is_parent'] != 0) {
    //   errorMessage = 'Цей логін вже зареєстрований на батьківський акаунт!';
    //   _showErrorDialog(errorMessage);
    // }
    if (_apiData['exists'] == false &&
        _apiData['authenticated'] == true &&
        _apiData['user']['is_parent'] == 0) {
      setState(() {
        _isLoading = true;
        Navigator.pushNamed(context, '/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
        height: _authMode == AuthMode.Signup ? 380 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 380 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Логін'),
                  // keyboardType: TextInputType.emailAddress,
                  controller: _loginController,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value.isEmpty) {
                            // if (value.isEmpty || !value.contains('@')) {
                            return 'Введіть логін!';
                          }

                          if (!value.contains('@') && !isNumeric(value)) {
                            print(!value.contains('@'));
                            print(!isNumeric(value));
                            print(value);
                            print(value.runtimeType);
                            // if (value.isEmpty || !value.contains('@')) {
                            return 'Логін має бути  email або телефон!';
                          }
                        }
                      : (value) {
                          if (value.isEmpty) {
                            // if (value.isEmpty || !value.contains('@')) {
                            return 'Введіть логін!';
                          }
                        },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty) {
                      // if (value.isEmpty || value.length < 5) {
                      return 'Введіть пароль!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                // AnimatedContainer(
                //   constraints: BoxConstraints(
                //     minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                //     maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                //   ),
                //   duration: Duration(milliseconds: 300),
                //   curve: Curves.easeIn,
                //   child: FadeTransition(
                //     opacity: _opacityAnimation,
                //     child: SlideTransition(
                //       position: _slideAnimation,
                //       child: TextFormField(
                //         enabled: _authMode == AuthMode.Signup,
                //         decoration:
                //             InputDecoration(labelText: 'Підтвердіть пароль'),
                //         obscureText: true,
                //         validator: _authMode == AuthMode.Signup
                //             ? (value) {
                //                 if (value != _passwordController.text) {
                //                   return 'Пароль не співпадає!';
                //                 }
                //               }
                //             : null,
                //       ),
                //     ),
                //   ),
                // ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(labelText: "Ваше ім'я"),
                        controller: _usernameController,
                        // obscureText: true,
                        // validator: _authMode == AuthMode.Signup
                        //     ? (value) {
                        //         if (value.isEmpty) {
                        //           return "Введіть ім'я!";
                        //         }
                        //       }
                        //     : null,
                        onSaved: (value) {
                          _authData['username'] = value;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(
                      _authMode == AuthMode.Login ? 'ЛОГІН' : 'РЕЄСТРАЦІЯ',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Color(0xFFf06388),
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'РЕЄСТРАЦІЯ' : 'ЛОГІН'} '),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
