import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class IsLiked extends StatefulWidget {
  @override
  IsLiked(this.id, this.likes);
  String id;
  int likes;
  _IsLikedState createState() => _IsLikedState();
}

class _IsLikedState extends State<IsLiked> {
  CollectionReference users;
  bool _isLoading = false;
  String pic;
  String name;
  bool liked = false;
  void initState() {
    setState(() {
      _isLoading = true;
    });

    var firebaseUser = FirebaseAuth.instance.currentUser;
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('likes')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        print('Document data: ${widget.id}');

        // final snapShot = await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(firebaseUser.uid)
        //     .collection("likes")
        //     .doc(widget.id)
        //     .get();
        liked = true;
        // if (snapShot.exists) {
        //   print("true");
        //   liked = true;
        // return true;
        //it exists
        // }
        // else {
        //   print("false");
        //   liked = false;
        // return false;
        //not exists
        // }
        // pic = documentSnapshot.data()['picture'];
        // name = documentSnapshot.data()['name'];
        // print(pic);
      } else {
        liked = false;
        print(widget.id);
        print('Document does not exist on the database');
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SpinKitWanderingCubes(
            color: Colors.red,
            size: 20,
          )
        : !liked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   flag = !flag;
                      // });
                      setState(() {
                        liked = true;
                      });
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('likes')
                          .doc(widget.id)
                          .set({});
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.id)
                          .set({
                        "likes": widget.likes + 1,
                      }, SetOptions(merge: true));
                      widget.likes += 1;
                      // print(document.id);
                    },
                    child: Container(
                      child: Row(children: [
                        Icon(Icons.thumb_up, color: Colors.black),
                        Text(" Like "),
                        Text(widget.likes.toString())
                      ]),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   flag = !flag;
                      // });
                      setState(() {
                        liked = false;
                      });
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .collection('likes')
                          .doc(widget.id)
                          .delete();

                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.id)
                          .set({
                        "likes": widget.likes - 1,
                      }, SetOptions(merge: true));
                      widget.likes -= 1;
                      // print(document.id);
                    },
                    child: Row(children: [
                      Icon(Icons.thumb_up, color: Colors.red),
                      Text(
                        " Liked ",
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(widget.likes.toString())
                    ]),
                  ),
                ],
              );
  }
}
