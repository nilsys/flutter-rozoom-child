import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';

class EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  bool _isLoading = false;

  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    Provider.of<Profile>(context, listen: false)
        .updateUserInfo('email=${_emailController.text}')
        .then((_) {
      _emailController.clear();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Consumer<Profile>(
        builder: (ctx, profile, child) => Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 0.0),
              child: TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) {
                  _saveForm();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введіть email';
                  }
                  if (!value.contains('@')) {
                    return 'Введіть email вірного формату';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: profile.profileItems['email'].email,
                  suffixIcon: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          onPressed: () {
                            _saveForm();
                          },
                          icon: Icon(
                            Icons.save,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
