import 'package:firetrial/activity/Schedule/edit_schedule.dart';
import 'package:firetrial/activity/Schedule/schedule_algorithm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GridPage extends StatefulWidget {
  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  // List to store the weekly schedule
  Map<String, dynamic> schedule = {};
  Map<String, List<int>> selectedHours = {};

  @override
  void initState() {
    super.initState();
    // Generate the initial schedule when the page is first created
    if (selectedHours.isEmpty) {
      fetchSelectedHoursFromSharedPreferences().then((retrievedSelectedHours) {
        setState(() {
          selectedHours = retrievedSelectedHours;
          generateSchedule();
        });
      });
    } else {
      generateSchedule();
    }
  }

  Future<Map<String, List<int>>>
      fetchSelectedHoursFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('selected_hours') ?? '{}';
    Map<String, dynamic> decodedData = jsonDecode(jsonData);

    // Convert dynamic decoded data to Map<String, List<int>>
    Map<String, List<int>> selectedHours = {};
    decodedData.forEach((key, value) {
      selectedHours[key] = List<int>.from(value.map((hour) => int.parse(hour)));
    });

    return selectedHours;
  }

  // Method to generate the schedule using the CourseScheduler class
  void generateSchedule() {
    CourseScheduler courseScheduler =
        CourseScheduler(selectedHours: selectedHours);
    schedule = courseScheduler.distributeCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grid Page')),
      body: _buildGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the bottom sheet when the button is pressed
          Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) {
              return edit_schedule(
                schedule: schedule,
                selectedHours: selectedHours,
              );
            }),
          ));
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildGrid() {
    final List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: daysOfWeek.length,
      itemBuilder: (context, index) {
        return _buildGridItem(
          daysOfWeek[index],
          schedule[daysOfWeek[index]] ?? [],
        );
      },
    );
  }

  Widget _buildGridItem(String dayOfWeek, List<String> courses) {
    List<int> availableHours = selectedHours[dayOfWeek] ?? [];
    String availableTimeString = availableHours.isEmpty
        ? 'No available time slots'
        : availableHours.map((hour) => '$hour:00').join(', ');

    String courseAssigned = courses.isNotEmpty
        ? courses.map((course) => 'Course_$course').join(', ')
        : 'No course assigned';

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            dayOfWeek,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Available Time: $availableTimeString',
            style: TextStyle(color: Colors.blue[900]),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: _buildCoursesList(courses),
          ),
          SizedBox(height: 8.0),
          Text(
            'Course Assigned: $courseAssigned',
            style: TextStyle(color: Colors.blue[900]),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(List<String> courses) {
    if (courses.length <= 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          courses.length,
          (index) => Text(
            '${index + 1}:00 AM - ${courses[index]}',
            style: TextStyle(color: Colors.blue[900]),
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            '${index + 1}:00 AM - ${courses[index]}',
            style: TextStyle(color: Colors.blue[900]),
          ),
        ),
      );
    }
  }
}
