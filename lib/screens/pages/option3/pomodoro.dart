import 'dart:async';
import 'package:flutter/material.dart';


class PomodoroPage extends StatefulWidget {
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int workDuration = 25;
  int breakDuration = 5;
  Timer? timer;
  int timeRemaining = 25 * 60;
  bool isRunning = false;
  bool isBreak = false;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          // Timer is over, switch to break or work based on the current mode
          if (isBreak) {
            timeRemaining = workDuration * 60;
            isBreak = false;
          } else {
            timeRemaining = breakDuration * 60;
            isBreak = true;
          }
        }
      });
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      timeRemaining = workDuration * 60;
      isBreak = false;
    });
  }

  void startStopTimer() {
    setState(() {
      isRunning = !isRunning;
    });

    if (isRunning) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;

    String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return formattedTime;
  }

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
              isBreak ? 'Break Time' : 'Work Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              formatTime(timeRemaining),
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? null : resetTimer,
                  child: Text('Reset'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: startStopTimer,
                  child: Text(isRunning ? 'Pause' : 'Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
