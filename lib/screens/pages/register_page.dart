import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/button.dart';
import 'package:firetrial/screens/components/text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailTextController = TextEditingController();
  final passswordTextController = TextEditingController();
  final confirmpwTextController = TextEditingController();
  //display error msg
  void displayMsg(String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(msg),
            ));
  }

  //sign up
  void signUp() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    //make sure passwords match
    if (passswordTextController.text != confirmpwTextController.text) {
      Navigator.pop(context);
      //show error to user
      displayMsg("Passwords dont Match");
      return;
    }
    //try creating user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passswordTextController.text);
      //create a new document
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email!)
          .set({
        'username': emailTextController.text.split('@')[0],
        //add additional fields if needed
      });
      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //show error
      displayMsg(e.code);
    }
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
                const Text("Let's Get Started"),
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
                  height: 15,
                ),
                //confirm password
                MyTextField(
                    controller: confirmpwTextController,
                    hintText: "Confirm password",
                    obscureText: true),
                const SizedBox(
                  height: 25,
                ),
                //sigin up button
                MyButton(onTap: signUp, text: "Sign Up"),

                //go tologin page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already having an account?",
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
                          "Login",
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
