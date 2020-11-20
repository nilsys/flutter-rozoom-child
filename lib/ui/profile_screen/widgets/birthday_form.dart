import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';

class BirthdayForm extends StatefulWidget {
  @override
  _BirthdayFormState createState() => _BirthdayFormState();
}

class _BirthdayFormState extends State<BirthdayForm> {
  DateTime selectedDate;

  bool _isLoading = false;

  final _form = GlobalKey<FormState>();
  final _birthdayController = TextEditingController();

  @override
  void initState() {
    final birthday = Provider.of<Profile>(context, listen: false)
        .profileItems['birthday']
        .birthday;
    final parsedBirhday = DateTime.parse(birthday);
    selectedDate = parsedBirhday;
    print('selectedDate -----------> $selectedDate');
    print('selectedDate type -----------> ${selectedDate.runtimeType}');
    selectedDate = parsedBirhday;
    print('selectedDate -----------> $selectedDate');
    super.initState();
  }

  @override
  void dispose() {
    _birthdayController.dispose();
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
    final dateToString = selectedDate
        .toString()
        .replaceRange(10, selectedDate.toString().length, '');
    print('dateToString --------------> $dateToString');
    Provider.of<Profile>(context, listen: false)
        .updateUserInfo('birthday=$dateToString')
        .then((_) {
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
                  'День народження',
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 0.0),
              child: TextFormField(
                showCursor: false,
                readOnly: true,
                decoration: InputDecoration(
                  // hintText: selectedDate.toString(),
                  hintText: "${selectedDate.toLocal()}".split(' ')[0],
                  prefixIcon: IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      ),
                      onPressed: () async {
                        print('selected date -------> $selectedDate');
                        final DateTime picked = await showDatePicker(
                            context: context,
                            locale: Locale('uk', 'UK'),
                            initialDate: selectedDate, // Refer step 1
                            firstDate: DateTime(1970),
                            lastDate: DateTime(2021),
                            fieldLabelText: 'Наберіть дату вручну',
                            errorFormatText: 'Введіть дату у вірному форматі',
                            errorInvalidText: 'Введіть дату у вірному форматі',
                            // fieldHintText: 'Місяць/День/Рік',
                            helpText: 'Оберіть дату народження');
                        if (picked != null && picked != selectedDate)
                          setState(() {
                            selectedDate = picked;
                            print('new selectedDate ---> $selectedDate');
                          });
                      }),
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
