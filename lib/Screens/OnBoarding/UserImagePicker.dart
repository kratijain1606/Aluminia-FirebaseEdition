import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter/material.dart";
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.pickImageFn, this.imageUrl, this.status);
  final void Function(File pickedImage) pickImageFn;
  final String imageUrl;
  final bool status;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  void _pickImage() async {
    final pickedImage = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    setState(() {
      _pickedImage = pickedImage;
    });

    widget.pickImageFn(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        CircleAvatar(
            radius: 100,
            backgroundImage: _pickedImage == null
                ? CachedNetworkImageProvider(widget.imageUrl)
                : FileImage(_pickedImage)),
        !widget.status
            ? FlatButton.icon(
                textColor: Theme.of(context).primaryColor,
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text(
                  'Add Image',
                  style: TextStyle(fontSize: height * 20 / 740),
                ))
            : Container(),
      ],
    );
  }
}
