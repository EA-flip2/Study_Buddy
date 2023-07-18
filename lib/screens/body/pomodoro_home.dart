import 'dart:async';

import 'package:firetrial/screens/body/pomodoro_home.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PomodoroPage(),
    );
  }
}

class PomodoroPage extends StatefulWidget {
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int _minutes = 25;
  int _seconds = 0;
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_minutes:${_seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton (
                  onPressed: _isRunning ? null : _startTimer,
                  child: Text('Start'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : null,
                  child: Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    // Start the timer
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_minutes == 0 && _seconds == 0) {
          timer.cancel(); // Timer finished, stop it
          _isRunning = false;
        } else if (_seconds == 0) {
          _minutes--;
          _seconds = 59;
        } else {
          _seconds--;
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
  }
}


