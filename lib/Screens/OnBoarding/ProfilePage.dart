import 'dart:io';
import 'package:aluminia/Screens/OnBoarding/UserImagePicker.dart';
import 'package:aluminia/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePage({this.picUrl});
  final picUrl;
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

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

  User firebaseUser = FirebaseAuth.instance.currentUser;
  bool isSelected = false;
  bool val = true;

  String _fetchedimageUrl;

  int selectedIndex;
  init() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
      setState(() {
        _namecontroller.text = documentSnapshot.data()['name'] ?? "";
        _dobcontroller.text = documentSnapshot.data()['dob'] ?? "";
        _contactcontroller.text = documentSnapshot.data()['phone'] ?? "";
        _fetchedimageUrl = documentSnapshot.data()['picture'];
      });
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
                                      _pickedImage, _fetchedimageUrl, _status),
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
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
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
                                      !_status
                                          ? new Text(
                                              'Name',
                                              style: TextStyle(
                                                  fontSize: height * 16.0 / 740,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container(),
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
                                          hintText: "Name"),
                                      enabled: !_status,
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
                                      !_status
                                          ? new Text(
                                              'DOB',
                                              style: TextStyle(
                                                  fontSize: height * 16.0 / 740,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                            child: ListTile(
                              title: pickedDate == null
                                  ? Text(
                                      "D.O.B.",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18, color: Colors.grey),
                                    )
                                  : Text(
                                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                      )),
                              onTap: !_status ? _pickDate : () {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25.0, 0, 25, 0),
                            child: Divider(
                              color: Colors.grey,
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
                                      !_status
                                          ? new Text(
                                              'Contact',
                                              style: TextStyle(
                                                  fontSize: height * 16.0 / 740,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container(),
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
                                          hintText: "Contact"),
                                      enabled: !_status,
                                      autofocus: !_status,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[],
                              )),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
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

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                child: RaisedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _status = true;
                    });
                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('profile_images')
                        .child(firebaseUser.uid + '.jpg');
                    if (_userImageFile != null) {
                      await ref.putFile(_userImageFile).onComplete;
                      imgUrl = await ref.getDownloadURL();
                    } else {
                      imgUrl = _fetchedimageUrl;
                    }
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(firebaseUser.uid)
                        .set({
                      "picture": imgUrl,
                      "name": _namecontroller.text,
                      "dob": _dobcontroller.text,
                      "phone": _contactcontroller.text
                    }, SetOptions(merge: true));
                  },
                  color: blu,
                  textColor: Colors.white,
                  child: Text("Update"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(700 / 797.7 * 20)),
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.redAccent,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: blu,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
    );

    if (date != null)
      setState(() {
        pickedDate = date;
      });
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
