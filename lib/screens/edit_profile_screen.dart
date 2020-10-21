import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/widgets/profile/birthday_form.dart';
import 'package:rozoom_app/widgets/profile/email_form.dart';
import 'package:rozoom_app/widgets/profile/password_form.dart';
import 'package:rozoom_app/widgets/profile/phone_form.dart';
import 'package:rozoom_app/widgets/profile/user_image_picker.dart';
import 'package:rozoom_app/widgets/profile/username_form.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    print('isloading');
    Provider.of<Profile>(context, listen: false).getProfileInfo().then((_) {
      print('get profile info');
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                            child: Column(
                              children: <Widget>[
                                UsernameForm(),
                                UserImagePicker()
                              ],
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
                                  EmailForm(),
                                  PhoneForm(),
                                  BirthdayForm()
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
                                PasswordForm(),
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
