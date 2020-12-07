import 'dart:io';
import 'package:aluminia/Home.dart';
import 'package:aluminia/Screens/OnBoarding/Education.dart';
import 'package:aluminia/Services/auth.dart';
import 'package:aluminia/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  double h, w;
  String name, contact, gender, image;
  Auth auth = new Auth();
  File _imageFile;
  final picker = ImagePicker();
  DateTime pickedDate;
  int _radiobtnvalue = -1;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: !loading
            ? SingleChildScrollView(
                child: Column(
                children: [
                  SizedBox(
                    height: 0.1 * h,
                  ),
                  Center(
                      child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: blu,
                    shape: CircleBorder(),
                    child: GestureDetector(
                      onTap: () => {
                        // pickImage()
                      },
                      child: CircleAvatar(
                        radius: 0.1 * h,
                        backgroundColor: Colors.white,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile)
                            : AssetImage('assets/images/add.png'),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 0.05 * h,
                  ),
                  textInput("Name", false),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 0.1 * w, vertical: 0.015 * h),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.blue,
                            blurRadius: 15.0,
                            spreadRadius: -10),
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: pickedDate == null
                              ? Text(
                                  "D.O.B",
                                  style: GoogleFonts.poppins(
                                      fontSize: 18, color: Colors.grey),
                                )
                              : Text(
                                  "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                  ),
                                ),
                          trailing: Icon(Icons.keyboard_arrow_down),
                          onTap: _pickDate,
                        ),
                      ),
                    ),
                  ),
                  textInput("Contact", false),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      addRadio(0, 'Male'),
                      addRadio(1, 'Female'),
                      addRadio(2, 'Other'),
                    ],
                  ),
                  SizedBox(
                    height: 0.05 * h,
                  ),
                  FloatingActionButton(
                    onPressed: () => {
                      setState(() {
                        loading = !loading;
                      }),
                      auth
                          .addUser(name, pickedDate.toString(), gender,
                              _imageFile, contact)
                          .then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Education()));
                      })
                    },
                    backgroundColor: blu,
                    child: Icon(Icons.keyboard_arrow_right, size: 40),
                  )
                ],
              ))
            : Center(child: CircularProgressIndicator()));
  }

  Widget textInput(String hintText, bool obscure) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.1 * w, vertical: 0.015 * h),
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(color: Colors.blue, blurRadius: 10.0, spreadRadius: -8),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle:
                    GoogleFonts.poppins(color: Colors.grey, fontSize: 18)),
            obscureText: obscure,
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
            onChanged: (value) {
              setState(() {
                if (hintText == "Name") this.name = value;
                if (hintText == "Contact") this.contact = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
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
