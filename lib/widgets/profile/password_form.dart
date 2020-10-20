import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';

class PasswordForm extends StatefulWidget {
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool _isLoading = false;
  bool _showPassword = false;

  final _form = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _passwordFocusNode.dispose();
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
        .updateUserInfo('password=${_newPasswordController.text}')
        .then((_) {
      _newPasswordController.clear();
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
                  'Зміна паролю',
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 0.0),
              child: TextFormField(
                controller: _newPasswordController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введіть пароль';
                  }
                },
                obscureText: !this._showPassword,
                decoration: InputDecoration(
                  hintText: 'Введіть новий пароль',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: this._showPassword
                          ? Theme.of(context).accentColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => this._showPassword = !this._showPassword);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 0.0),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                focusNode: _passwordFocusNode,
                onFieldSubmitted: (_) {
                  _saveForm();
                },
                obscureText: !this._showPassword,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введіть пароль';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Паролі не співпадають!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Введіть новий пароль ще раз',
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
