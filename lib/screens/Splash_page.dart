import 'package:firetrial/authentication/auth.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Add this import for Timer
import 'package:firetrial/main.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startTimer(); // Call the function to start the timer
  }

  // Function to navigate to the main widget after the specified duration
  void _startTimer() {
    const splashDuration =
        Duration(seconds: 3); // Adjust the duration as needed

    Timer(splashDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Auth_Page()),
      ); // Replace current screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Study Buddy',
              style: TextStyle(
                fontSize: 36,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Widget'),
      ),
      body: Center(
        child: Text('Welcome to the Main Widget!'),
      ),
    );
  }
}
