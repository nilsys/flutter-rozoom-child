import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/profile_provider.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  // UserImagePicker(this.imagePickFn);

  // final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      // maxWidth: 150,
    );

    setState(() {
      _pickedImage = pickedImageFile;
      print('image picker file path ${_pickedImage.path}');
      Provider.of<Profile>(context, listen: false)
          .sendAvatar(_pickedImage.path);
    });
    // widget.imagePickFn(pickedImageFile);
    // print('${widget.imagePickFn(pickedImageFile)}');
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<Profile>(context).getAvatarUrl;
    return Container(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundImage:
                // NetworkImage(userInfo)
                _pickedImage != null
                    ? FileImage(_pickedImage)
                    : NetworkImage(userInfo),
          ),
          FlatButton.icon(
            textColor: Color(0xFF74bec9),
            // onPressed: _pickImage,
            onPressed: _pickImage,
            icon: Icon(Icons.camera_alt),
            label: Text('Змінити аватар'),
          )
        ],
      ),
    );
  }
}
