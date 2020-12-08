import 'package:aluminia/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter/material.dart";
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.pickImageFn, this.imageUrl, this.profileImage);
  final void Function(File pickedImage) pickImageFn;
  final String profileImage;
  String imageUrl;

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
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         fit: BoxFit.cover,
          //         image: _pickedImage != null
          //             ? FileImage(_pickedImage)
          //             : CachedNetworkImageProvider(widget.imageUrl)
          //             )),
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: _pickImage,
            icon: Icon(
              Icons.image,
              size: 32,
              color: blu,
            ),
            label: Text(
              'Add Image',
              style: GoogleFonts.comfortaa(fontSize: 32, color: blu),
            )),
      ],
    );
  }
}
