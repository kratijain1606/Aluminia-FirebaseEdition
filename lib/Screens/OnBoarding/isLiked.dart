import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IsLiked extends StatefulWidget {
  @override
  IsLiked(this.id);
  String id;
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
        ? Center(child: CircularProgressIndicator())
        : !liked
            ? GestureDetector(
                onTap: () {
                  // setState(() {
                  //   flag = !flag;
                  // });
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
                    "like": true,
                  }, SetOptions(merge: true));

                  // print(document.id);
                },
                child: Container(
                  child: Row(children: [
                    Icon(Icons.thumb_up, color: Colors.black),
                    Text(" Like")
                  ]),
                ),
              )
            : GestureDetector(
                onTap: () {
                  // setState(() {
                  //   flag = !flag;
                  // });
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
                    "like": false,
                  }, SetOptions(merge: true));

                  // print(document.id);
                },
                child: Row(children: [
                  Icon(Icons.thumb_up, color: Colors.red),
                  Text(
                    " Like",
                    style: TextStyle(color: Colors.red),
                  )
                ]),
              );
  }
}
