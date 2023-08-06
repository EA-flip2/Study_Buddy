import 'package:firetrial/activity/Schedule/select_available_time.dart';
import 'package:firetrial/activity/change_course.dart';
import 'package:firetrial/tools/avaliability.dart';
import 'package:flutter/material.dart';

import '../../activity/Schedule/schedule_view.dart';

class activity extends StatefulWidget {
  const activity({super.key});

  @override
  State<activity> createState() => _activityState();
}

class _activityState extends State<activity> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoopingOptions(),
      ),
    );
  }
}

class LoopingOptions extends StatefulWidget {
  @override
  _LoopingOptionsState createState() => _LoopingOptionsState();
}

class _LoopingOptionsState extends State<LoopingOptions> {
  /*
    if shared preferences is empty, call GridofHours to assign it
    else
    Map<String, List<int>>selectHours = what is stored sharedPreferences
  
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20), // Add spacing between options
          _buildOption1(),
          SizedBox(height: 20), // Add spacing between options
          _buildOption2(),
          SizedBox(height: 20), // Add spacing between options
          _buildOption3(),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index) {
    if (index == 0) {
      return _buildOption1();
    } else if (index == 1) {
      return _buildOption2();
    } else if (index == 2) {
      return _buildOption3();
    } else {
      return Container();
    }
  }

  Widget _buildOption1() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text('Previous Course'),
          subtitle: Text('Course Name'),
        ),
        ListTile(
          title: Text('Upcoming Course'),
          subtitle: Text('Course Name'),
        ),
        ListTile(
          title: Text('Edit'),
          onTap: () {
            _showEditDialog();
          },
        ),
      ],
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Change Availability'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AvailabilityPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Change Course'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeCoursePage()),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption2() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GridPage()),
        );
      },
      child: Container(
        height: 300.0, // You can adjust this height as needed
        color: Colors.blue, // Set the color for Option 2
        child: Center(
          child: Text(
            'Schedule',
            style: TextStyle(fontSize: 24.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildOption3() {
    return Container(
      height: 400.0, // You can adjust this height as needed
      color: Colors.green, // Set the color for Option 3
      child: Center(
        child: Text(
          'Option 3 Content',
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
      ),
    );
  }
}
