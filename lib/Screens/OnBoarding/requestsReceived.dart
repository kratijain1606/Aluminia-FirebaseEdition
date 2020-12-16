import 'package:aluminia/Screens/OnBoarding/ConnectionProfile.dart';
import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsReceived extends StatefulWidget {
  @override
  RequestsReceived({this.collection, this.flag});
  final int flag;
  final String collection;
  _RequestsReceivedState createState() => _RequestsReceivedState();
}

String img = "";
List<String> name;
List<String> id;
List<String> imgUrl;

class _RequestsReceivedState extends State<RequestsReceived> {
  CollectionReference users;
  bool _isLoading = false;
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();
    init();
  }

  init() async {
    users = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('requestReceived');
    setLogin();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(widget.collection)
        .get()
        .then((querySnapshot) {
      //print(querySnapshot);
      int i = 0;
      id = new List(querySnapshot.docs.length);
      name = new List(querySnapshot.docs.length);
      imgUrl = new List(querySnapshot.docs.length);
      print("users: results: length: " + querySnapshot.docs.length.toString());
      querySnapshot.docs.forEach((value) {
        print("y");
        print(i);
        print(id.length);
        id[i] = value.id;
        print(name[i]);
        i++;
      });
    }).catchError((onError) {
      print("getCloudFirestoreUsers: ERROR");
      print(onError);
    });
    String n;

    // call();
    for (int i = 0; i < id.length; i++) {
      getName(i, id[i]);
    }
  }

  getName(i, id) async {
    String n;
    id = id.toString().trim();
    print("here is id" + id.toString());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((DocumentSnapshot ds) {
      n = ds.data()['name'];
      name[i] = ds.data()['name'];
      imgUrl[i] = ds.data()['picture'];
      // print(ds.data());
      print("n");
      print(imgUrl[i]);
      print(n);
    });

    setState(() {
      _isLoading = false;
    });
  }

  setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', true);
  }

  void dispose() {
//  _everySecond.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
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
        body: _isLoading
            ? Center(
                child: SpinKitWanderingCubes(
                color: Colors.red,
                size: 20,
              ))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: name.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                                width: 60,
                                                height: 60,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.green,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            imgUrl[index]))),
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
                                                    name[index],
                                                    style:
                                                        GoogleFonts.comfortaa(
                                                            color: blu,
                                                            fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text("Student",
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                ])
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: widget.flag == 1
                                              ? FlatButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            .uid)
                                                        .collection(
                                                            'Connections')
                                                        .doc(id[index])
                                                        .set({});
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            .uid)
                                                        .collection(
                                                            'requestReceived')
                                                        .doc(id[index])
                                                        .delete();
                                                    setState(() {
                                                      init();
                                                      // _isLoading = !_isLoading;
                                                    });
                                                  },
                                                  color: blu,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Text(
                                                    "Accept",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                              :
                                              //  Container()
                                              FlatButton(
                                                  onPressed: () {
                                                    // ConnectionProfilePage()
                                                    // setState(() {
                                                    //   init();
                                                    //   // _isLoading = !_isLoading;
                                                    // });
                                                  },
                                                  color: blu,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Text(
                                                    "Chat",
                                                    style: TextStyle(
                                                        color: Colors.white),
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
                  // body:
                }));
  }
}
