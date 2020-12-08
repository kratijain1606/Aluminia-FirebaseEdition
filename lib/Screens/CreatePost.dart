import 'dart:io';
import 'package:aluminia/Screens/OnBoarding/PostImagePicker.dart';
import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSimpleDialogBox(BuildContext context, String message) {
  showDialog(
    context: context,
    child: AlertDialog(
      content: Text(message),
      actions: [
        FlatButton(
          child: Text("okay"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    ),
  );
}

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

TextEditingController _controller = new TextEditingController();
FocusNode _descriptionsnode = FocusNode();
String url;
User firebaseUser = FirebaseAuth.instance.currentUser;
File _userImageFile;
void _pickedImage(File image) {
  _userImageFile = image;
}

String profileimage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTOyEXAbv0XrpFyGfpuRgw_3SItiGapPbWYwg&usqp=CAU';
String _fetchedimageUrl;

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
      url = documentSnapshot.data()['picture'];
      _fetchedimageUrl = documentSnapshot.data()['picture'];
    });
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aluminia",
          style: GoogleFonts.comfortaa(color: blu, fontSize: 32),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 0.05 * width),
              child: CircleAvatar(
                child: Icon(Icons.person),
                backgroundColor: blu,
              ))
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.green,
                          backgroundImage: NetworkImage(url))),
                  Row(
                    children: [
                      FlatButton(
                        color: blu,
                        child: Text(
                          "Share Post",
                          style: GoogleFonts.comfortaa(
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          addPost();
                          showSimpleDialogBox(
                              context, "Your achievement has been posted");
                          _controller.clear();
                        },
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    20 * width / 411, height * 10 / 740, 20 * width / 411, 0),
                child: TextFormField(
                  controller: _controller,
                  focusNode: _descriptionsnode,
                  decoration: InputDecoration(
                    hintText: "Add description to your post",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 15,
                )),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: Divider(
                thickness: 10,
              ),
            ),
            UserImagePicker(_pickedImage, _fetchedimageUrl, profileimage),
          ],
        ),
      ),
    );
  }

  Future<void> addPost() {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return posts
        .add({
          'description': _controller.text
          // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
