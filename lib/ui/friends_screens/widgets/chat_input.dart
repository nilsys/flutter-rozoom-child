import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/friends_provider.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/loader_widget.dart';

class ChatInput extends StatefulWidget {
  String id;
  ChatInput({this.id});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _form = GlobalKey<FormState>();
  final _inputController = TextEditingController();

  bool _isLoading = false;
  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return _isLoading
        ? myLoaderWidget()
        : Form(
            key: _form,
            child: Container(
              height: defaultSize * 8,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color(0xFFF391A0).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: _inputController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              print(value);
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              // suffixIcon: Icon(
                              //   Icons.face,
                              //   color: Color(0xFFF391A0),
                              //   size: 35,
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      onPressed: () {
                        _saveForm();
                      },
                      icon: Icon(
                        Icons.thumb_up,
                        size: 35,
                        color: Color(0xFFF391A0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  _saveForm() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    Provider.of<Friends>(context, listen: false)
        .sendMessage(widget.id, _inputController.text)
        .then((value) => {
              setState(() {
                _isLoading = false;
              })
            });
    _inputController.clear();
  }
}
