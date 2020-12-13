import 'dart:io';
import 'package:aluminia/Screens/OnBoarding/UserImagePicker.dart';
import 'package:aluminia/Services/auth.dart';
import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectionProfilePage extends StatefulWidget {
  @override
  ConnectionProfilePage({this.ds, this.id});
  final DocumentSnapshot ds;
  final String id;
  MapScreenState createState() => MapScreenState();
}

Auth auth = new Auth();

class MapScreenState extends State<ConnectionProfilePage>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  bool flag = true;
  String gender;

  int _radiobtnvalue = -1;
  @override
  void initState() {
    super.initState();
    init();
  }

  String imgUrl = "";
  File _userImageFile;
  DateTime pickedDate;
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _dobcontroller = TextEditingController();
  TextEditingController _contactcontroller = TextEditingController();
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  String dob;
  User firebaseUser = FirebaseAuth.instance.currentUser;
  bool isSelected = false;
  bool val = true;

  String _fetchedimageUrl;

  int selectedIndex;
  init() async {
    setState(() {
      _namecontroller.text = widget.ds.data()['name'] ?? "";
      _dobcontroller.text = widget.ds.data()['dob'] ?? "";
      _contactcontroller.text = widget.ds.data()['phone'] ?? "";
      _fetchedimageUrl = widget.ds.data()['picture'];
      dob = _dobcontroller.text;
      print(dob);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return new Scaffold(
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
        body: Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: height * 20 / 740),
                          child: new Stack(
                            fit: StackFit.loose,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  UserImagePicker(
                                      _pickedImage, _fetchedimageUrl, true),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: height * 25.0 / 740),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: height * 25.0 / 740,
                                right: height * 25.0 / 740,
                                top: height * 25.0 / 740),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      'Personal Information',
                                      style: TextStyle(
                                          fontSize: height * 18.0 / 740,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: height * 25.0 / 740,
                                  right: height * 25.0 / 740,
                                  top: height * 25.0 / 740),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: height * 16.0 / 740,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: height * 25.0 / 740,
                                  right: height * 25.0 / 740,
                                  top: height * 2.0 / 740),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: _namecontroller,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Name"),
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: height * 25.0 / 740,
                                  right: height * 25.0 / 740,
                                  top: height * 25.0 / 740),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Date of birth',
                                        style: TextStyle(
                                            fontSize: height * 16.0 / 740,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                            child: ListTile(
                              title: dob.length == 0
                                  ? Text(
                                      "D.O.B.",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18, color: Colors.grey),
                                    )
                                  : Text(dob,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                      )),
                              onTap: () {},
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: height * 25.0 / 740,
                                  right: height * 25.0 / 740,
                                  top: height * 25.0 / 740),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Contact no.',
                                        style: TextStyle(
                                            fontSize: height * 16.0 / 740,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: height * 25.0 / 740,
                                  right: height * 25.0 / 740,
                                  top: height * 2.0 / 740),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      keyboardType: TextInputType.number,
                                      controller: _contactcontroller,
                                      decoration: const InputDecoration(
                                          hintText: "Contact",
                                          border: InputBorder.none),
                                      enabled: false,
                                      autofocus: false,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  flag
                      ? RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: blu,
                          onPressed: () {
                            auth.addConnection(widget.id);

                            setState(() {
                              flag = !flag;
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Connect",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25))),
                        )
                      : RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.grey,
                          onPressed: () {},
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Connected",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25))),
                        )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Row addRadio(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: blu,
          value: btnValue,
          groupValue: _radiobtnvalue,
          onChanged: _handleradiobutton,
        ),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16),
        )
      ],
    );
  }

  void _handleradiobutton(int value) {
    setState(() {
      _radiobtnvalue = value;
      switch (value) {
        case 0:
          gender = "male";
          break;
        case 1:
          gender = "female";
          break;
        case 2:
          gender = 'other';
          break;
        default:
          gender = null;
      }
    });
  }
}
