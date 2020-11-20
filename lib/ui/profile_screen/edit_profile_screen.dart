import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/auth_provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';
import 'package:rozoom_app/shared/widgets/loader_widget.dart';
import 'package:rozoom_app/ui/home_screens/index_screen.dart';
import 'package:rozoom_app/ui/profile_screen/widgets/birthday_form.dart';
import 'package:rozoom_app/ui/profile_screen/widgets/email_form.dart';
import 'package:rozoom_app/ui/profile_screen/widgets/password_form.dart';
import 'package:rozoom_app/ui/profile_screen/widgets/phone_form.dart';
import 'package:rozoom_app/ui/profile_screen/widgets/user_image_picker.dart';
import 'package:rozoom_app/ui/profile_screen/widgets/username_form.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
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
            Navigator.of(context).pop();
          },
        ),
        title: Consumer<Profile>(
          builder: (ctx, profile, child) => profile.isLoadingScreen
              ? myLoaderWidget()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 35),
                    Image.asset('assets/images/stats/coin.png', scale: 0.55),
                    SizedBox(width: 5),
                    Text(profile.profileItems['uom'].uom,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    SizedBox(width: 10),
                    Image.asset('assets/images/stats/uah.png', height: 30),
                    SizedBox(width: 5),
                    Text(profile.profileItems['balance'].balance,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
        ),
      ),
      body: SingleChildScrollView(
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
                        children: <Widget>[UsernameForm(), UserImagePicker()],
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
