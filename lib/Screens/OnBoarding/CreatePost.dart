import 'dart:io';
import 'package:aluminia/Screens/OnBoarding/PostImagePicker.dart';
import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

String imgUrl = "";
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

bool _isLoading = false;

class _PostState extends State<Post> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
      url = documentSnapshot.data()['picture'];
      _fetchedimageUrl = documentSnapshot.data()['picture'];
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aluminia",
          style: GoogleFonts.comfortaa(color: blu, fontSize: 32),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: SpinKitWanderingCubes(
              color: Colors.red,
              size: 20,
            ))
          : SingleChildScrollView(
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
                                backgroundImage:
                                    // AssetImage('assets/images/PSe.jpeg')
                                    NetworkImage(url))),
                        Row(
                          children: [
                            UserImagePicker(
                                _pickedImage, _fetchedimageUrl, profileimage),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20 * width / 411,
                        height * 10 / 740, 20 * width / 411, 0),
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
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                    child: Divider(
                      thickness: 10,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    color: blu,
                    child: Text(
                      "Share Post",
                      style: GoogleFonts.comfortaa(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () async {
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child('post_images')
                          .child(_userImageFile.path);
                      if (_userImageFile != null) {
                        await ref.putFile(_userImageFile).onComplete;
                        imgUrl = await ref.getDownloadURL();
                      } else {
                        imgUrl = _fetchedimageUrl;
                      }

                      addPost(imgUrl);
                      showSimpleDialogBox(
                          context, "Your achievement has been posted");
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> addPost(String imgUrl) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return posts
        .add({
          "picture": imgUrl,
          'description': _controller.text,
          'likes': 0,
          'displayDesc': false
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
