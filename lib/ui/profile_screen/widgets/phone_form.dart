import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';

class PhoneForm extends StatefulWidget {
  @override
  _PhoneFormState createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  bool _isLoading = false;

  final _form = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
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
        .updateUserInfo('phone=${_phoneController.text}')
        .then((_) {
      _phoneController.clear();
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
                  'Телефон',
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 0.0),
              child: TextFormField(
                controller: _phoneController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                onFieldSubmitted: (_) {
                  _saveForm();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введіть телефон';
                  }
                  if (int.tryParse(value) == null) {
                    return 'У номері можуть бути тільки цифри';
                  }
                  if (value.length < 10) {
                    return 'Номер не може бути меньш ніж 10 цифр';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: profile.phone,
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
