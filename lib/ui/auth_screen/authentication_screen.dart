import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/models/exceptions.dart';
import 'package:rozoom_app/core/providers/auth_provider.dart';

import 'package:rozoom_app/shared/widgets/fade-animation.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: Image.asset('assets/images/auth/blue-circle-hq.png'),
                  ),
                  Positioned(
                      // left: 50,
                      // top: 20,
                      child: FadeAnimation(
                    2,
                    Container(
                      padding: EdgeInsets.only(left: 50, top: 20),
                      child: Image.asset(
                        'assets/images/auth/boy-hq.png',
                        scale: 1.1,
                      ),
                    ),
                  )),
                ],
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
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _loginFocusNode = FocusNode();

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };

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
    _controller.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _loginController.dispose();
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).signin(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
          _authData['username'],
        );
      }
      // Navigator.of(context).pushReplacementNamed(HomeChild.routeName);
    } on HttpException catch (error) {
      var errorMessage = error.toString();

      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Щось пішло не так. Спробуйте ще';
      _showErrorDialog(errorMessage);
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
        height: _authMode == AuthMode.Signup ? 340 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 340 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FadeAnimation(
                  2.6,
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                ),
                FadeAnimation(
                  2.8,
                  _authMode == AuthMode.Signup
                      ? TextFormField(
                          decoration: InputDecoration(labelText: 'Пароль'),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Введіть пароль!';
                            }
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_loginFocusNode);
                          },
                          focusNode: _passwordFocusNode,
                        )
                      : TextFormField(
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
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _submit();
                          },
                          focusNode: _passwordFocusNode,
                        ),
                ),
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
                        textInputAction: TextInputAction.done,
                        focusNode: _loginFocusNode,
                        onFieldSubmitted: (_) {
                          _submit();
                        },
                        onSaved: (value) {
                          print('value ------------------$value');
                          _authData['username'] = value != '' ? value : 'Пусто';
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
                  FadeAnimation(
                    3,
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
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                FadeAnimation(
                  3.2,
                  FlatButton(
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'РЕЄСТРАЦІЯ' : 'ЛОГІН'} '),
                    onPressed: _switchAuthMode,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
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
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
