import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetUser extends StatefulWidget {
  @override
  GetUser({this.id});

  final String id;
  _GetUserState createState() => _GetUserState();
}

class _GetUserState extends State<GetUser> {
  CollectionReference users;
  bool _isLoading = false;
  String pic;
  String name;
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // print('Document data: ${documentSnapshot.data()}');

        pic = documentSnapshot.data()['picture'];
        name = documentSnapshot.data()['name'];
        print(pic);
      } else {
        print('Document does not exist on the database');
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    width: 0.95 * w,
                    // height: 0.15 * h,
                    child: GestureDetector(
                      onTap: () {},
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          color: Colors.white,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.green,
                                            // child: Center(
                                            //   child: FadeInImage
                                            //       .assetNetwork(
                                            //     placeholder:
                                            //         'assets/images/AJ.jpg',
                                            //     image: document
                                            //         .data()['picture'],
                                            //   ),
                                            // ),
                                            backgroundImage:
                                                // AssetImage('assets/images/PSe.jpeg')
                                                NetworkImage(pic))),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            name,
                                            // FirebaseFirestore.instance.collection('users').doc(document.id).get(),
                                            // document.data()['name'],
                                            style: GoogleFonts.comfortaa(
                                                color: blu, fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Student",
                                              // document
                                              //     .data()['gender'],
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ])
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: FlatButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .collection('Connections')
                                            .doc(widget.id)
                                            .set({});
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .collection('requestReceived')
                                            .doc(widget.id)
                                            .delete();

                                        // auth.addConnection(
                                        //     document.id);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ConnectionProfilePage(
                                        //                 ds: document,
                                        //                 id: document
                                        //                     .id)
                                        //                     ));
                                      },
                                      color: blu,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                        "Accept",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          );
  }
}
