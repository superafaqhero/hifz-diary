import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/admin/bottom_navigation.dart';
import 'package:hafiz_diary/authentication/login_screen.dart';
import 'package:hafiz_diary/parents/parents_bottom_navigation.dart';
import 'package:hafiz_diary/parents/parents_login.dart';
import 'package:hafiz_diary/staff/staff_bottom_navigation.dart';

import 'role_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
        (value) {
          if (value.get("type") == 0) {
            Timer(
              const Duration(seconds: 5),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomeNavigation(),
                ),
              ),
            );
          } else if (value.get("type") == 1) {
            Timer(
              const Duration(seconds: 5),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StaffBottomNavigation(isApproved: value.get("status")),
                ),
              ),
            );
          } else {
            Timer(
              const Duration(seconds: 5),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ParentsLogin(
                          isApproved: value.get("status"),
                        )

                    ),
              ),
            );
          }
        },
      );
    } else {
      Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RolePage(),
          ),
        ),
      );
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Image.asset("assets/images/logo.png")],
        ),
      ),
    );
  }
}
