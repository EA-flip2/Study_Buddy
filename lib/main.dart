import 'package:firetrial/authentication/auth.dart';
import 'package:firetrial/screens/body/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firetrial/newfeatures/pomodoro.dart';
void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  /* final CollectionReference tagsDB =
      FirebaseFirestore.instance.collection("collectionPath");*/

  const MyApp({super.key});
  // creatings data base:

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Auth_Page(),
    );
  
  }
}
@override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      debugShowCheckedModeBanner: true, 
      title: 'Study Buddy', 
      theme: ThemeData( 
        primarySwatch: Colors.blue, 
        visualDensity: VisualDensity.adaptivePlatformDensity, 
      ), 
      home: SplashPage(), 
    ); 
  } 

