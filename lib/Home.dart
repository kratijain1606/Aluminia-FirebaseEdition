import 'package:aluminia/Services/auth.dart';
import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Auth auth = new Auth();

class _HomeState extends State<Home> {
  double w, h;

  void initState() {
    super.initState();
    setLogin();
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
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aluminia",
          style: GoogleFonts.comfortaa(color: blu, fontSize: 32),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 0.05 * w),
              child: CircleAvatar(
                child: Icon(Icons.person),
                backgroundColor: blu,
              ))
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: posts.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
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
                                                  child:
                                                      !document.data()[
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
                                          // width: 250,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            image: DecorationImage(
                                              image:
                                                  // NetworkImage(
                                                  //     document.data()['picture']),
                                                  AssetImage(
                                                      'assets/images/A1.jpeg'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 5,
                                // color: blu,
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                ),
                                !document.data()['like']
                                    ? GestureDetector(
                                        onTap: () {
                                          // setState(() {
                                          //   flag = !flag;
                                          // });
                                          FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(document.id)
                                              .set({
                                            "like": true,
                                          }, SetOptions(merge: true));

                                          // print(document.id);
                                        },
                                        child: Container(
                                          child: Row(children: [
                                            Icon(Icons.thumb_up,
                                                color: Colors.black),
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
                                              .collection('posts')
                                              .doc(document.id)
                                              .set({
                                            "like": false,
                                          }, SetOptions(merge: true));

                                          // print(document.id);
                                        },
                                        child: Row(children: [
                                          Icon(Icons.thumb_up,
                                              color: Colors.red),
                                          Text(
                                            " Like",
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ]),
                                      ),
                                SizedBox(
                                  width: 0.1 * w,
                                ),
                                // Icon(Icons.share),
                                // Text(" Share"),
                                // SizedBox(
                                //   width: 0.1 * w,
                                // ),
                                // Icon(Icons.comment),
                                // Text(" Comment")
                              ],
                            )),
                      ],
                    ));
              }
            }).toList());
          }),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {},
      // ),
    );
  }
}
