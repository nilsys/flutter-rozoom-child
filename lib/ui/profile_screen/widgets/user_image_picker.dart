import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  // UserImagePicker(this.imagePickFn);

  // final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      // maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
      print('image picker file path ${_pickedImage.path}');
      Provider.of<Profile>(context, listen: false)
          .sendAvatar(_pickedImage.path);
    });
    // widget.imagePickFn(pickedImageFile);
    // print('${widget.imagePickFn(pickedImageFile)}');
  }

  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      // imageQuality: 50,
      // maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage.path);

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
    final avatarUrl =
        Provider.of<Profile>(context).profileItems['avatarUrl'].avatarUrl;
    return Container(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundImage:
                // NetworkImage(userInfo)
                _pickedImage != null
                    ? FileImage(_pickedImage)
                    : NetworkImage(avatarUrl),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                // textColor: Color(0xFF74bec9),
                // onPressed: _pickImage,
                onPressed: _pickImageFromCamera,
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).accentColor,
                ),
                // label: Text('Змінити аватар'),
              ),
              Text(
                'Змінити аватар',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
              IconButton(
                // textColor: Color(0xFF74bec9),
                // onPressed: _pickImage,
                onPressed: _pickImageFromGallery,
                icon: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).accentColor,
                ),
                // label: Text('Змінити аватар'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
