import 'package:aluminia/Screens/OnBoarding/WorkHistory.dart';
import 'package:aluminia/Services/auth.dart';
import 'package:aluminia/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Education extends StatefulWidget {
  @override
  _EducationState createState() => _EducationState();
}

class EducationParameters {
  String school;
  String degree;
  DateTime startDate;
  DateTime endDate;
  EducationParameters(this.school, this.degree, this.startDate, this.endDate);
}

class _EducationState extends State<Education> {
  var list = List<EducationParameters>();
  var count = 1;
  Auth auth = new Auth();
  DateTime pickedDate1;
  DateTime pickedDate2;
  String schoolName, degree, startDate, endDate;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Education History",
            style: GoogleFonts.comfortaa(color: blu, fontSize: 32),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: w * 40 / 740,
            ),
            Container(
              height: 0.7 * h,
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext ctx, int index) {
                  return Expanded(
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                (index + 1).toString(),
                                style: GoogleFonts.comfortaa(fontSize: 22),
                              ),
                            ],
                          ),
                          textInput("School Name", false, index),
                          textInput("Degree", false, index),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ListTile(
                                  title: pickedDate1 == null
                                      ? Text(
                                          "Start Date",
                                          style: GoogleFonts.poppins(
                                              fontSize: 18, color: Colors.grey),
                                        )
                                      : Text(
                                          "${pickedDate1.day}-${pickedDate1.month}-${pickedDate1.year}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                          ),
                                        ),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                  onTap: _pickDate1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ListTile(
                                  title: pickedDate2 == null
                                      ? Text(
                                          "End Date",
                                          style: GoogleFonts.poppins(
                                              fontSize: 18, color: Colors.grey),
                                        )
                                      : Text(
                                          "${pickedDate2.day}-${pickedDate2.month}-${pickedDate2.year}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                          ),
                                        ),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                  onTap: _pickDate2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  count++;
                  auth.addEducation(schoolName, degree, pickedDate1.toString(),
                      pickedDate2.toString());

                  addEducation();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  count > 1
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              count--;
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Icon(
                                Icons.remove,
                                color: blu,
                              ),
                              Text(
                                "Clear",
                                style: GoogleFonts.comfortaa(
                                    color: blu, fontSize: 22),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.add,
                        color: blu,
                      ),
                      Text(
                        "Add New",
                        style: GoogleFonts.comfortaa(color: blu, fontSize: 22),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              child: Text(
                "Save",
                style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 22),
              ),
              color: blu,
              onPressed: () {
                auth
                    .addEducation(schoolName, degree, pickedDate1.toString(),
                        pickedDate2.toString())
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WorkHistory()));

                  addEducation();
                  print("L");
                  for (var i = 0; i < list.length; i++) {
                    print('${list[i].school}');

                    print('${list[i].degree}');
                    print('${list[i].startDate}');
                    print('${list[i].endDate}');
                    print("");
                  }
                  print(list.length);
                });
              },
            )
          ],
        )));
  }

  Widget textInput(String hintText, bool obscure, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                if (hintText == "School Name") {
                  this.schoolName = value;
                  list[index].school = value;
                  list[index].school = this.schoolName;
                  print(list.length);
                }
                if (hintText == "Degree") {
                  this.degree = value;
                  list[index].degree = value;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  _pickDate1() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
    );

    if (date != null)
      setState(() {
        pickedDate1 = date;
      });
  }

  _pickDate2() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
    );

    if (date != null)
      setState(() {
        pickedDate2 = date;
      });
  }

  void addEducation() async {
    EducationParameters edu =
        new EducationParameters(schoolName, degree, pickedDate1, pickedDate2);
    list.add(edu);
    print(list);
  }
}
