import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/profile_provider.dart';
import 'package:rozoom_app/widgets/pickers/user_image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = false;

  bool _validate = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();
  // final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Profile>(context, listen: false).getProfileInfo().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: null,
        ),
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
        title: _isLoading
            ? Text('')
            : Consumer<Profile>(
                builder: (ctx, profile, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Text(
                    //   'Дісципліни',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    SizedBox(
                      width: 35,
                    ),
                    Image.asset(
                      'assets/images/stats/coin.png',
                      // height: 300,
                      scale: 0.55,
                      // width: 50,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      profile.balance,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/stats/uah.png',
                      height: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      profile.certificates,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          elevation: 3,
                          margin: EdgeInsets.only(
                              top: 20, bottom: 0, left: 20, right: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Consumer<Profile>(
                              builder: (ctx, profile, child) => Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(
                                        'Nickname',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20.0, top: 0.0),
                                    child: TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        hintText: profile.name,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            Provider.of<Profile>(context,
                                                    listen: false)
                                                .updateUserInfo(
                                                    'name=${_usernameController.text}')
                                                .then((_) {
                                              _usernameController.clear();
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.save,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  UserImagePicker()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          elevation: 3,
                          margin: EdgeInsets.only(
                              top: 20, bottom: 0, left: 20, right: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Consumer<Profile>(
                              builder: (ctx, profile, child) => Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(
                                        'Email',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, top: 0.0),
                                    child: TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        hintText: profile.email,
                                        errorText:
                                            _validate ? "Введіть email" : null,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _emailController.text.isEmpty
                                                  ? _validate = true
                                                  : _validate = false;
                                              _isLoading = true;
                                            });

                                            Provider.of<Profile>(context,
                                                    listen: false)
                                                .updateUserInfo(
                                                    'email=${_emailController.text}')
                                                .then((_) {
                                              _emailController.clear();
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.save,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Телефон',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, top: 10.0),
                                    child: TextFormField(
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                        hintText: profile.phone,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            Provider.of<Profile>(context,
                                                    listen: false)
                                                .updateUserInfo(
                                                    'phone=${_phoneController.text}')
                                                .then((_) {
                                              _usernameController.clear();
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.save,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'День народження',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, top: 10.0),
                                    child: TextFormField(
                                      controller: _birthdayController,
                                      decoration: InputDecoration(
                                        hintText: profile.birthday.replaceRange(
                                            10, profile.birthday.length, ''),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            Provider.of<Profile>(context,
                                                    listen: false)
                                                .updateUserInfo(
                                                    'birthday=${_birthdayController.text}')
                                                .then((_) {
                                              _birthdayController.clear();
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.save,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          elevation: 3,
                          margin: EdgeInsets.only(
                              top: 20, bottom: 20, left: 20, right: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Text(
                                      'Зміна паролю',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, top: 0.0),
                                  child: TextFormField(
                                    controller: _newPasswordController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Введіть пароль!';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Введіть новий пароль',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20.0, top: 0.0),
                                  child: TextFormField(
                                    // controller: _newPasswordController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Введіть пароль!';
                                      }

                                      if (value !=
                                          _newPasswordController.text) {
                                        return 'Пароль не співпадає!';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Введіть новий пароль ще раз',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLoading = true;
                                          });

                                          Provider.of<Profile>(context,
                                                  listen: false)
                                              .updateUserInfo(
                                                  'password=${_newPasswordController.text}')
                                              .then((_) {
                                            _newPasswordController.clear();
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          });
                                        },
                                        icon: Icon(
                                          Icons.save,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
