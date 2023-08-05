import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firetrial/screens/components/button.dart';
import 'package:firetrial/screens/components/text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailTextController = TextEditingController();
  final passswordTextController = TextEditingController();

  // Google Sign-In
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Show loading circle
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      // Hide loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Hide loading circle
      Navigator.pop(context);
      displayMsg(e.code);
    }
  }

  //user sign in
  void signIn() async {
    //loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passswordTextController.text);
      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      displayMsg(e.code);
    }
  }

  //display error msg
  void displayMsg(String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(msg),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                // Spotify-Inspired Image (Replace with your own image)
                Image.asset(
                  'assets/images/band.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 25,
                ),
                //welcome back
                const Text("Welcome To Study Buddy"),
                const SizedBox(
                  height: 25,
                ),
                //Textfied
                MyTextField(
                  controller: emailTextController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                //password textfield
                MyTextField(
                  controller: passswordTextController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                //sigin in button
                MyButton(onTap: signIn, text: "Sign In"),

                // Google Sign-In Button
                ElevatedButton(
                  onPressed: _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Replace with Spotify green color or any desired color
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/google.png', // Replace with Google logo
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account yet?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Create an account",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

