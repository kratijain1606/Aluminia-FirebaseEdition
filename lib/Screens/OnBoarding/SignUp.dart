import 'package:aluminia/Screens/OnBoarding/UserInfo.dart';
import 'package:aluminia/Services/auth.dart';
import 'package:aluminia/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  double h, w;
  String email,
      ptemp,
      password,
      emailError = "",
      ptempError = "",
      passwordError = "";
  Auth auth = new Auth();

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 0.1 * h,
              ),
              Center(
                child: Text("Join the network!",
                    style: GoogleFonts.poppins(fontSize: 36, color: blu)),
              ),
              SizedBox(
                height: 0.1 * h,
              ),
              textInput("Email", false),
              Text(emailError,
                  style: TextStyle(fontSize: 12, color: Colors.red)),
              textInput("Password", true),
              Text(ptempError,
                  style: TextStyle(fontSize: 12, color: Colors.red)),
              textInput("Confirm Password", true),
              Text(passwordError,
                  style: TextStyle(fontSize: 12, color: Colors.red)),
              SizedBox(
                height: 0.1 * h,
              ),
              RaisedButton(
                onPressed: () => {
                  print("press"),
                  if (email == null || !EmailValidator.validate(email))
                    {
                      setState(() {
                        emailError = "Please enter a valid email";
                      })
                    }
                  else if (ptemp == null)
                    {
                      setState(() {
                        emailError = "";
                        ptempError = "Password cannot be empty";
                      })
                    }
                  else if (ptemp != password)
                    {
                      setState(() {
                        ptempError = "";
                        passwordError = "Password mismatch";
                      })
                    }
                  else
                    {
                      setState(() {
                        emailError = "";
                        ptempError = "";
                        passwordError = "";
                      }),
                      auth.createAccount(email, password).then((value) =>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfo()))),
                    }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: blu,
                elevation: 5,
                child: Text(
                  "SignUp",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 0.1 * w, vertical: 0.01 * h),
              )
            ],
          ),
        ));
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
                if (hintText == "Email") this.email = value;
                if (hintText == "Password") this.ptemp = value;
                if (hintText == "Confirm Password") this.password = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
