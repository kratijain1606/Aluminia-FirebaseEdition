import 'package:aluminia/BottomNavigation.dart';
import 'package:aluminia/Screens/OnBoarding/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Aluminia(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Aluminia extends StatefulWidget {
  @override
  _AluminiaState createState() => _AluminiaState();
}

class _AluminiaState extends State<Aluminia> {
  bool loading = true, login = false;

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
    checkLogin();
  }

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _login = prefs.getBool('login');
    if (_login != null) {
      setState(() {
        login = _login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: loading
            ? Center(child: CircularProgressIndicator())
            : login ? MainPage() : Login(),
      ),
    );
  }
}
