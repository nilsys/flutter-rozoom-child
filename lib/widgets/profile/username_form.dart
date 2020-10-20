import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';

class UsernameForm extends StatefulWidget {
  @override
  _UsernameFormState createState() => _UsernameFormState();
}

class _UsernameFormState extends State<UsernameForm> {
  bool _isLoading = false;

  final _form = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
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
        .updateUserInfo('name=${_usernameController.text}')
        .then((_) {
      _usernameController.clear();
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
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  'Nickname',
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 0.0),
              child: TextFormField(
                controller: _usernameController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _saveForm();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введіть Nickname';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: profile.name,
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
