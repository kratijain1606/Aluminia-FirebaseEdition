import 'dart:io';

import 'package:aluminia/Screens/OnBoarding/Login.dart';
import 'package:aluminia/Screens/OnBoarding/isLiked.dart';
import 'package:aluminia/Services/auth.dart';
import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  // @override
  _HomeState createState() => _HomeState();
}

Auth auth = new Auth();

class _HomeState extends State<Home> {
  double w, h;
  bool _isLoading = false;
  void initState() {
    super.initState();
    init();
    setLogin();
  }

  CollectionReference posts;
  init() async {
    setState(() {
      bool _isLoading = true;
    });

    posts = FirebaseFirestore.instance.collection('posts');
    setState(() {
      bool _isLoading = false;
    });
  }

  setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', true);
  }

  bool status = true;

  bool flag = true;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aluminia",
          style: GoogleFonts.comfortaa(color: blu, fontSize: 32),
        ),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            items: [
              DropdownMenuItem(
                value: 'LogOut',
                child: Container(
                  child: Text('LogOut'),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == "LogOut") {
                logOut(h, w);
              }
            },
          )
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: posts.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                  {
                    return Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                                width: 0.8 * w,
                                // height: 0.5 * h,
                                child: GestureDetector(
                                  onTap: () {
                                    print(document.data()['picture']);
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                // Text(document.data()['description']),
                                                Expanded(
                                                  child: Container(
                                                      width: 0.6 * w,
                                                      child: !document.data()[
                                                              'displayDesc']
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'posts')
                                                                    .doc(
                                                                        document
                                                                            .id)
                                                                    .set({
                                                                  "displayDesc":
                                                                      true,
                                                                }, SetOptions(merge: true));
                                                              },
                                                              child: Container(
                                                                child: Text(
                                                                    document.data()[
                                                                        'description'],
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'posts')
                                                                    .doc(
                                                                        document
                                                                            .id)
                                                                    .set({
                                                                  "displayDesc":
                                                                      false,
                                                                }, SetOptions(merge: true));
                                                              },
                                                              child: Text(document
                                                                      .data()[
                                                                  'description']),
                                                            )),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Container(
                                              height: 0.6 * w,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                image: DecorationImage(
                                                  image: NetworkImage(document
                                                      .data()['picture']),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 5,
                                    // color: blu,
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                    ),
                                    IsLiked(
                                        document.id, document.data()['likes']),
                                    SizedBox(
                                      width: 0.1 * w,
                                    ),
                                  ],
                                )),
                          ],
                        ));
                  }
                }).toList());
              }),
    );
  }

  logOut(double height, double width) {
    return DialogBox(context, auth);
  }

  void DialogBox(BuildContext context, Auth _auth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("signOut"),
          content: new Text("signOut"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("yes"),
              onPressed: () async {
                // await _auth.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs?.clear();
                //             Navigator.pushAndRemoveUntil(
                //   context,
                //  ModalRoute.withName("/Home")
                // );
                // Navigator.pushAndRemoveUntil(
                //     context, newRoute, (route) => false);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("no"))
          ],
        );
      },
    );
  }
}
