import 'package:aluminia/Screens/OnBoarding/ConnectionProfile.dart';
import 'package:aluminia/Services/auth.dart';
import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

String img = "";

class _UsersListState extends State<UsersList> {
  double w, h;

  CollectionReference users;
  bool _isLoading = false;
  Auth auth = new Auth();
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();
    users = FirebaseFirestore.instance.collection('users');
    setLogin();

    setState(() {
      _isLoading = false;
    });
  }

  getImage(DocumentSnapshot ds) async {
    img = await ds.data()['picture'];
  }

  setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', true);
  }

  List<bool> list;

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
        leading: Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 0.05 * w),
              child: CircleAvatar(
                child: Icon(Icons.person),
                backgroundColor: blu,
              )),
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
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
                    list = new List(snapshot.data.size);
                    print(snapshot.data.size);
                    getImage(document);
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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

                                                          // AssetImage(
                                                          //     'assets/images/PSe.jpeg')
                                                          NetworkImage(
                                                              document.data()[
                                                                  'picture']))),
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
                                                      document.data()['name'],
                                                      style:
                                                          GoogleFonts.comfortaa(
                                                              color: blu,
                                                              fontSize: 18),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text("Student",
                                                        // document
                                                        //     .data()['gender'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  ])
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: FlatButton(
                                                onPressed: () {
                                                  // auth.addConnection(
                                                  //     document.id);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConnectionProfilePage(
                                                                  ds: document,
                                                                  id: document
                                                                      .id)));
                                                },
                                                color: blu,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Text(
                                                  "Profile",
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
                  }
                }).toList());
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
