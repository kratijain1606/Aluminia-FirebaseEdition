import 'package:aluminia/Chat.dart';
import 'package:aluminia/Home.dart';
import 'package:aluminia/Screens/OnBoarding/CreatePost.dart';
import 'package:aluminia/Screens/OnBoarding/ProfilePage.dart';
import 'package:aluminia/Screens/OnBoarding/users.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

int _currentIndex = 0;
bool _isSearching = false;

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      Home(),
      UsersList(),
      Chat()
    ];
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          currentIndex: _currentIndex,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          onTap: _changePage,
          items: [
            BottomNavigationBarItem(
                title: Text(
                  "home",
                  style: TextStyle(fontSize: width * 15 / 400),
                ),
                icon: Icon(
                  Icons.home,
                )),
            BottomNavigationBarItem(
                title: Text(
                  "Users",
                  style: TextStyle(fontSize: width * 15 / 400),
                ),
                icon: Icon(Icons.people)),
            BottomNavigationBarItem(
                title: Text(
                  "Chat",
                  style: TextStyle(fontSize: width * 15 / 400),
                ),
                icon: Icon(Icons.chat)),
          ]),
    );
  }

  void _changePage(index) {
    setState(() {
      _currentIndex = index;
      _isSearching = false;
    });
  }
}
