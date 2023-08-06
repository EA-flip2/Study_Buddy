import 'package:firetrial/activity/change_course.dart';
import 'package:firetrial/screens/pages/option3/pomodoro.dart';
import 'package:firetrial/tools/avaliability.dart';
import 'package:flutter/material.dart';
import 'Timetable.dart';


class Option3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0, // You can adjust this height as needed
      color: Colors.green, // Set the color for Option 3
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          //ListTile(
           // title: Text('Item 1'),
           // onTap: () {
              // Navigate to another page when Item 1 is tapped
              //Navigator.push(
               // context,
                //MaterialPageRoute(builder: (context) => AnotherPage()), // Replace 'AnotherPage' with the desired page widget
             // );
           // },
         // ),
         // ListTile(
           // title: Text('Item 2'),
            //onTap: () {
              // Navigate to another page when Item 2 is tapped
             // Navigator.push(
              //  context,
               // MaterialPageRoute(builder: (context) => AnotherPage()), // Replace 'AnotherPage' with the desired page widget
              //);
            //},
          //),
          ListTile(
            title: Text('Pomodoro Timer'),
            onTap: () {
              // Navigate to the PomodoroPage when 'Pomodoro Timer' is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PomodoroPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}





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
  // Sample data for days of the week, time, and course name
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<String> timeList = ['9:00 AM', '1:00 PM', '4:00 PM'];
  final List<String> courseNameList = ['Course A', 'Course B', 'Course C'];

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
     return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PomodoroPage()), // Replace with your NewPage widget
      );
    },
     child: Container(height: 400.0, // You can adjust this height as needed
      color: Colors.green, // Set the color for Option 3
      child: const Center(
        child: Text(
          'Option 3 Content',
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
      ),
    )); 
  }

  Widget _buildTableRow(String dayOfWeek) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayOfWeek,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              timeList.length,
              (index) => Text(
                '${timeList[index]} - ${courseNameList[index]}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
