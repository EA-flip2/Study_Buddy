import 'package:firetrial/activity/Schedule/schedule_algorithm.dart';
import 'package:firetrial/activity/change_course.dart';
import 'dart:convert';
import 'package:firetrial/tools/avaliability.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Map<String, List<int>> selectedHours = {};
  Map<String, List<String>> schedule = {};

  @override
  void initState() {
    super.initState();
    // Load the data from shared preferences when the widget is created
    loadDataFromSharedPreferences();
    loadDataSchedule();
  }

  void loadDataSchedule() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? jsonString = preferences.getString('current_schedule');
    if (jsonString != null && jsonString.isNotEmpty) {
      // If there is data in shared preferences, decode the JSON and update the schedule
      Map<String, dynamic> decodedData = jsonDecode(jsonString);
      setState(() {
        schedule = {};
        decodedData.forEach((day, courses) {
          schedule[day] =
              List<String>.from(courses.map((course) => course.toString()));
        });
      });
    } else {
      // If shared preferences is empty or no 'current_schedule' key is found, you can decide what to do.
      // For example, you can initialize the schedule as an empty map or leave it as it is.
    }
  }

  void loadDataFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? jsonString = preferences.getString('selected_hours');
    if (jsonString != null && jsonString.isNotEmpty) {
      // If there is data in shared preferences, decode the JSON and update selectedHours
      Map<String, dynamic> decodedData = jsonDecode(jsonString);
      setState(() {
        selectedHours = {};
        decodedData.forEach((day, hours) {
          selectedHours[day] =
              List<int>.from(hours.map((hour) => int.parse(hour)));
        });
      });
    } else {
      // If shared preferences is empty, call GridOfHours to assign it
      // You can choose to do this here or when the app first launches, depending on your use case.
      // Example: selectedHours = GridOfHours().selectedHours;
    }
  }
  /*
    if shared preferences is empty, call GridofHours to assign it
    else
    Map<String, List<int>>selectedHours = what is stored sharedPreferences
  
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
            MaterialPageRoute(
                builder: (context) => SchedulePage(
                      selectedHours: selectedHours,
                      schedule: schedule,
                    )));
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
