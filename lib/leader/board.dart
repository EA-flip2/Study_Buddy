import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  final int completedPomodoroSessions;
  final int breaksTaken;

  LeaderboardPage({
    required this.completedPomodoroSessions,
    required this.breaksTaken,
  });

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  // Add your logic here to implement the leaderboard functionality,
  // such as fetching data from a database, calculating rankings, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Ranking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Completed Pomodoro Sessions: ${widget.completedPomodoroSessions}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Breaks Taken: ${widget.breaksTaken}',
              style: TextStyle(fontSize: 16),
            ),
            // Add other leaderboard data and rankings as needed
          ],
        ),
      ),
    );
  }
}
