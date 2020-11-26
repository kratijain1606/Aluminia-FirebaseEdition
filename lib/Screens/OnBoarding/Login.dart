import 'package:aluminia/Home.dart';
import 'package:aluminia/Screens/OnBoarding/SignUp.dart';
import 'package:aluminia/Screens/OnBoarding/UserInfo.dart';
import 'package:aluminia/Services/auth.dart';
import 'package:aluminia/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {

  double h,w;
  String email, password;
  Auth auth = new Auth();
  bool loading = false;

  @override    
  Widget build(BuildContext context) {    
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold( 
      resizeToAvoidBottomPadding: false,
      body: !loading ? SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 0.1 * h,
            ),
            Center(
              child: Container(
                child: Image.asset('assets/images/logo.png'),
              )
            ),
            SizedBox(
              height: 0.1 * h,
            ),
            textInput("Email", false),
            textInput("Password", true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New User? "),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()))
                  },
                  child: Text("Sign up!", style: TextStyle(color: blu))
                )
              ],
            ),
            SizedBox(
              height: 0.1 * h,
            ),
            RaisedButton(
              onPressed: () => {
                setState(() {
                  loading = true;
                }),
                auth.signIn(email, password),
                auth.getUser(email).then(
                  (bool exists) {
                    if(exists)
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                    else
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfo()));
                  }
                )
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              color: blu,
              elevation: 5,
              child: Text(
                "Login",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0.1 * w, vertical: 0.01 * h),
            )
          ],
        ),
      ) : Center(
        child: CircularProgressIndicator()
      )
    );
  }
  Widget textInput(String hintText, bool obscure) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.1 * w, vertical: 0.02 * h),
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.blue,
            blurRadius: 10.0,
            spreadRadius: -8
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 18
              )
            ),
            obscureText: obscure,
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
            onChanged: (value) {
              setState(() {
                if(hintText == "Email") 
                  this.email = value;
                if(hintText == "Password")
                  this.password = value;
              });
            },
          ),
        ),
      ),
    );
  }
}