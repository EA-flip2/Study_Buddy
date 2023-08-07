import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PomodoroPage extends StatefulWidget {
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int workDuration = 10;
  int breakDuration = 5;
  Timer? timer;
  int timeRemaining = 10 * 60;
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

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'pomodoro_channel_id',
      'Pomodoro Channel',
      'Channel for Pomodoro Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          // Timer is over, show the dialog for interval selection
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Interval'),
                content: Text('Do you want to take a break or continue with work?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Continue with work
                      timeRemaining = workDurations[currentWorkDurationIndex] * 60;
                      isBreak = false;
                      startTimer();
                      Navigator.pop(context);
                    },
                    child: Text('Continue with Work'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Take a break
                      timeRemaining = breakDurations[currentBreakDurationIndex] * 60;
                      isBreak = true;
                      startTimer();
                      Navigator.pop(context);
                    },
                    child: Text('Take a Break'),
                  ),
                ],
              );
            },
          );

          // Show encouragement message based on the interval
          if (isBreak) {
            showEncouragement('Great job! Take a break and relax.');
          } else {
            showEncouragement('Well done! Keep going with your work.');
          }

          // Show notification based on the interval
          if (isBreak) {
            showNotification('Break Time', 'Your break time is up!');
          } else {
            showNotification('Work Time', 'Your work time is up!');
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

  void showEncouragement(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
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
