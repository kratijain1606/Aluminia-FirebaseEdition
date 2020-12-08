import 'dart:io';
import 'package:aluminia/client_secrets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imgur/imgur.dart' as imgur;

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User> get authStateChanges => auth.authStateChanges();
  UserCredential userCredential;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final client = imgur.Imgur(imgur.Authentication.fromToken(imgurAuth));

  createAccount(String email, String password) async {
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      await userCredential.user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
    } catch (e) {
      print(e);
    }
    return userCredential != null;
  }

  Future<void> addUser(String name, String dob, String gender, File _imageFile,
      String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');

    var firebaseUser = FirebaseAuth.instance.currentUser;
    var newId = firebaseUser.uid;
    return users
        .doc(newId)
        .set({
          'name': name,
          'email': email,
          'dob': dob,
          'gender': gender,
          'phone': phone
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addConnection(String id) async {
    User firebaseUser = FirebaseAuth.instance.currentUser;
    print(firebaseUser.uid);
    return users.doc(firebaseUser.uid).update({
      'connection': FieldValue.arrayUnion([id])
    });
  }

  Future<void> addEducation(String schoolName, String degree, String startDate,
      String endDate) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    print("uid");
    print(firebaseUser.uid);
    // return null;
    return users
        .doc(firebaseUser.uid)
        .set({
          'education': FieldValue.arrayUnion(
            [
              {
                'schoolName': schoolName,
                'degree': degree,
                'startDate': startDate,
                'endDate': endDate
              }
            ],
          ),
        }, SetOptions(merge: true))
        .then((value) => print("Education Added"))
        .catchError((error) => print("Failed to add education: $error"));
  }

  Future<void> addWork(String company, String designation, String startDate,
      String endDate) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    print("uid");
    print(firebaseUser.uid);
    return users
        .doc(firebaseUser.uid)
        .set({
          'WorkHistory': FieldValue.arrayUnion(
            [
              {
                'company': company,
                'designation': designation,
                'startDate': startDate,
                'endDate': endDate
              }
            ],
          ),
        }, SetOptions(merge: true))
        .then((value) => print("Education Added"))
        .catchError((error) => print("Failed to add education: $error"));
  }

  Future<String> uploadImage(File _imageFile) async {
    String url = "";
    await client.image
        .uploadImage(
            imagePath: _imageFile.path,
            title: 'A title',
            description: 'A description')
        .then((image) => url = image.link);
    return url;
  }

  Future<bool> getUser(String email) async {
    bool existing;
    await users
        .where('email', isEqualTo: email)
        .get()
        .then((value) => value.size == 0 ? existing = false : existing = true);
    return existing;
  }
}
