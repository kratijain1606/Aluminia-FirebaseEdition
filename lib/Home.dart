import 'package:aluminia/Screens/OnBoarding/Education.dart';
import 'package:aluminia/Screens/OnBoarding/users.dart';
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
              // itemCount: 10,
              // return  itemBuilder: (BuildContext context, int index) {
              {
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                            width: 0.8 * w,
                            height: 0.2 * h,
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => UsersList()));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(document.data()['description']),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 5,
                                color: blu,
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon(Icons.thumb_up_alt_outlined),
                                Icon(Icons.thumb_up),
                                Text(" Like"),
                                SizedBox(
                                  width: 0.1 * w,
                                ),
                                Icon(Icons.share),
                                // Icon(Icons.share_outlined),
                                Text(" Share"),
                                SizedBox(
                                  width: 0.1 * w,
                                ),
                                Icon(Icons.comment),
                                // Icon(Icons.share_outlined),
                                Text(" Comment")
                              ],
                            )),
                      ],
                    ));
              }
            }).toList());
          }),

      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //           padding: EdgeInsets.only(bottom: 0.1 * h),
      //           height: h,
      //           child: ListView.builder(
      //               itemCount: 10,
      //               itemBuilder: (BuildContext context, int index) {
      //                 return Container(
      //                   padding: EdgeInsets.all(10),
      //                   child: Column(
      //                     children: [
      //                       Container(
      //                           width: 0.8 * w,
      //                           height: 0.2 * h,
      //                           child: GestureDetector(
      //                             onTap: () {
      //                               Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(
      //                                       builder: (context) => UsersList()));
      //                             },
      //                             child: Card(
      //                               shape: RoundedRectangleBorder(
      //                                   borderRadius:
      //                                       BorderRadius.circular(15)),
      //                               elevation: 5,
      //                               color: blu,
      //                             ),
      //                           )),
      //                       Padding(
      //                           padding: EdgeInsets.symmetric(vertical: 10),
      //                           child: Row(
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               // Icon(Icons.thumb_up_alt_outlined),
      //                               Icon(Icons.thumb_up),
      //                               Text(" Like"),
      //                               SizedBox(
      //                                 width: 0.1 * w,
      //                               ),
      //                               Icon(Icons.share),
      //                               // Icon(Icons.share_outlined),
      //                               Text(" Share"),
      //                               SizedBox(
      //                                 width: 0.1 * w,
      //                               ),
      //                               Icon(Icons.comment),
      //                               // Icon(Icons.share_outlined),
      //                               Text(" Comment")
      //                             ],
      //                           ))
      //                     ],
      //                   ),
      //                 );
      //               }))
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
