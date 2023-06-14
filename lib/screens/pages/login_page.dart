import 'package:firebase_auth/firebase_auth.dart';
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
                //logo
                const Icon(
                  Icons.lock,
                  size: 100,
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
                    obscureText: false),
                const SizedBox(
                  height: 15,
                ),
                //password textfield
                MyTextField(
                    controller: passswordTextController,
                    hintText: "password",
                    obscureText: true),
                const SizedBox(
                  height: 25,
                ),
                //sigin in button
                MyButton(onTap: signIn, text: "Sign In"),

                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not a member?",
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
                          "Join us :)",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
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
