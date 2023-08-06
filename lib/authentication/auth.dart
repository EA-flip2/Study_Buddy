import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/authentication/login_reg.dart';
import 'package:firetrial/screens/body/navigator_.dart';
import 'package:flutter/material.dart';

class Auth_Page extends StatelessWidget {
  const Auth_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //user is logged in
        if (snapshot.hasData) {
          return const Navigate();
        } else {
          return LoginOrRegister();
        }
      },
    );
  }
}






