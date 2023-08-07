import 'package:flutter/material.dart';
import 'dart:math';

class SchedulePage extends StatelessWidget {
  final Map<String, List<int>> selectedHours;
  final Map<String, List<String>> schedule;

  SchedulePage({required this.selectedHours, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Page'),
        backgroundColor: Colors.blue[900], // Customizing the AppBar color
      ),
      backgroundColor: Colors.blue[50], // Customizing the background color
      body: ListView.builder(
        itemCount: selectedHours.keys.length,
        itemBuilder: (context, index) {
          String day = selectedHours.keys.elementAt(index);
          List<int> hours = selectedHours[day] ?? [];
          List<String> courses = schedule[day] ?? [];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // More rounded corners
            ),
            elevation: 4.0,
            margin: EdgeInsets.symmetric(
                vertical: 12.0, horizontal: 24.0), // Increased margins
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0), // Increased spacing
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12.0, // Increased spacing
                      mainAxisSpacing: 12.0, // Increased spacing
                    ),
                    itemCount: max(hours.length, courses.length),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, itemIndex) {
                      String course =
                          itemIndex < courses.length ? courses[itemIndex] : '';
                      int hour =
                          itemIndex < hours.length ? hours[itemIndex] : 0;

                      return Container(
                        padding: EdgeInsets.all(12.0), // Increased padding
                        decoration: BoxDecoration(
                          color: Colors.blue[200], // Lighter blue background
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hour > 0 ? hour.toString() + ":00" : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0, // Increased font size
                                color: Colors.blue[900],
                              ),
                            ),
                            SizedBox(height: 8.0), // Increased spacing
                            Text(
                              course,
                              style: TextStyle(
                                  fontSize: 16.0), // Increased font size
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
