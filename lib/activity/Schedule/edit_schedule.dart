import 'package:flutter/material.dart';

class edit_schedule extends StatefulWidget {
  final Map<String, List<int>> selectedHours;
  final Map<String, dynamic> schedule;

  edit_schedule({
    required this.selectedHours,
    required this.schedule,
  });

  @override
  _edit_scheduleState createState() => _edit_scheduleState();
}

class _edit_scheduleState extends State<edit_schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Widget')),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          String day = _getDayFromIndex(index);
          List<int> hours = widget.selectedHours[day] ?? [];
          List<dynamic> courses = widget.schedule[day] ?? [];

          return _buildDayTile(day, hours, courses);
        },
      ),
    );
  }

  Widget _buildDayTile(String day, List<int> hours, List<dynamic> courses) {
    return ExpansionTile(
      title: Text(day),
      children: List.generate(hours.length, (index) {
        int hour = hours[index];
        dynamic course = courses[index];
        return ListTile(
          title: Text('Time: ${hour}h'),
          subtitle: Text('Course: ${course.toString()}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _removeTile(day, hour);
              });
            },
          ),
        );
      }),
    );
  }

  void _removeTile(String day, int hour) {
    if (widget.selectedHours.containsKey(day) &&
        widget.schedule.containsKey(day)) {
      widget.selectedHours[day]!.remove(hour);
      widget.schedule[day]!.remove(hour);
    }
  }

  String _getDayFromIndex(int index) {
    // Assuming Monday is the first day of the week (index 0).
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[index];
  }
}
