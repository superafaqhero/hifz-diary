import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/admin/admin_home.dart';
import 'package:hafiz_diary/admin/bottom_navigation.dart';
import 'package:hafiz_diary/parents/parents_bottom_navigation.dart';
import 'package:hafiz_diary/parents/parents_login.dart';
import 'package:hafiz_diary/staff/staff_bottom_navigation.dart';
import 'package:translator/translator.dart';

class AuthServices {
  signup(
      {required String email,
      required String password,
      required Map<String, dynamic> data,
      required BuildContext context}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(value.user!.uid)
          .set(data)
          .whenComplete(() {
        if (data['type'] == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminHomeNavigation()));
        } else if (data['type'] == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StaffBottomNavigation(
                isApproved: data['status'],
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ParentsLogin(isApproved: data['status'])
                  // ParentsBottomNavigation(isApproved: data['status']),
            ),
          );
        }
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    });
  }

  login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(value.user!.uid)
          .get()
          .then((value) {
        if (value.get("type") == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminHomeNavigation()));
        } else if (value.get("type") == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StaffBottomNavigation(isApproved: value.get("status")),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ParentsLogin(isApproved: value.get("status")),
              // ParentsBottomNavigation(isApproved: value.get("status"))
            ),
          );
        }
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    });
  }
}
Future<String> translator({required String text, required String lang}) async {
  final translator = GoogleTranslator();



  var translation = await translator.translate(text, to: lang);
  String translated=translation as String;
  print(translation);
  // prints Dart jest bardzo fajny!

  return translated;
  // prints exemplo
}
