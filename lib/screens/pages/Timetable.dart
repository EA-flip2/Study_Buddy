import 'package:flutter/material.dart';

class GridPage extends StatefulWidget {
  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grid Page')),
      body: _buildGrid(),
    );
  }

  Widget _buildGrid() {
    // Create a 7x3 grid with the days of the week as the first column
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
        return _buildGridItem(daysOfWeek[index]);
      },
    );
  }

  Widget _buildGridItem(String dayOfWeek) {
    // Sample data for time and course name
    final List<String> timeList = ['9:00 AM', '1:00 PM', '4:00 PM'];
    final List<String> courseNameList = ['Course A', 'Course B', 'Course C'];

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue[100], // Background color of each grid cell
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            dayOfWeek,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.blue[900]),
          ),
          SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              timeList.length,
              (index) => Text(
                '${timeList[index]} - ${courseNameList[index]}',
                style: TextStyle(color: Colors.blue[900]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
