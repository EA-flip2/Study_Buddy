import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Option 3'),
      ),
      body: Option3(),
    ),
  ));
}

class Option3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0, // You can adjust this height as needed
      color: Colors.green, // Set the color for Option 3
      child: PomodoroPage(), // Replace the content with the PomodoroPage widget
    );
  }
}

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

  List<int> workDurations = [
    10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100,
    105, 115, 120
  ]; // Different work durations
  List<int> breakDurations = [
    5, 10, 15, 20, 25, 30, 60
  ]; // Different break durations
  int currentWorkDurationIndex = 0;
  int currentBreakDurationIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          // Timer is over, switch to break or work based on the current mode
          if (isBreak) {
            timeRemaining = workDurations[currentWorkDurationIndex] * 60;
            isBreak = false;
          } else {
            timeRemaining = breakDurations[currentBreakDurationIndex] * 60;
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
      timeRemaining = workDurations[currentWorkDurationIndex] * 60;
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
            SizedBox(height: 20),
            Text(
              'Work Duration: ${workDurations[currentWorkDurationIndex]} minutes',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: currentWorkDurationIndex.toDouble(),
              onChanged: (newValue) {
                setState(() {
                  currentWorkDurationIndex = newValue.toInt();
                  timeRemaining = workDurations[currentWorkDurationIndex] * 60;
                  isBreak = false;
                  if (isRunning) {
                    stopTimer();
                    startTimer();
                  }
                });
              },
              min: 0,
              max: workDurations.length - 1.toDouble(),
              divisions: workDurations.length - 1,
              label: workDurations[currentWorkDurationIndex].toString(),
            ),
            SizedBox(height: 20),
            Text(
              'Break Duration: ${breakDurations[currentBreakDurationIndex]} minutes',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: currentBreakDurationIndex.toDouble(),
              onChanged: (newValue) {
                setState(() {
                  currentBreakDurationIndex = newValue.toInt();
                  if (isBreak) {
                    timeRemaining = breakDurations[currentBreakDurationIndex] * 60;
                  }
                  if (isRunning) {
                    stopTimer();
                    startTimer();
                  }
                });
              },
              min: 0,
              max: breakDurations.length - 1.toDouble(),
              divisions: breakDurations.length - 1,
              label: breakDurations[currentBreakDurationIndex].toString(),
            ),
          ],
        ),
      ),
    );
  }
}
