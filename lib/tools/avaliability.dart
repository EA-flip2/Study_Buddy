import 'package:firetrial/activity/Schedule/select_available_time.dart';
import 'package:flutter/material.dart';

class AvailabilityPage extends StatefulWidget {
  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  List<bool> availableHours = List.filled(24, false);
  List<int> selectedHours = [];
  bool is24HourFormat = true;
  String selectedDay = 'Monday'; // Default day is Monday

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Availability'),
      ),
      body: Column(
        children: [
          // Day dropdown button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedDay,
              items: daysOfWeek.map((day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedDay = newValue!;
                });
              },
            ),
          ),
          Divider(height: 1, thickness: 1), // Separator line
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 12),
              itemCount: 24,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      availableHours[index] = !availableHours[index];
                      if (availableHours[index]) {
                        selectedHours.add(index);
                      } else {
                        selectedHours.remove(index);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color:
                          availableHours[index] ? Colors.green : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        is24HourFormat
                            ? (index + 1).toString()
                            : _format12Hour(index + 1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GridOfHours();
                  }));
                });
              },
              child: Text("Reset Avaliability")),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog();
            },
            child: Text('Confirm'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                is24HourFormat = !is24HourFormat;
              });
            },
            child: Text(
                is24HourFormat ? 'Switch to 12-hour' : 'Switch to 24-hour'),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // List of days of the week titles
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String _format12Hour(int hour) {
    return hour > 12 ? '${hour - 12} PM' : '${hour} AM';
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected Day: $selectedDay'),
              SizedBox(height: 10),
              Text('Selected Hours: ${selectedHours.toString()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveSelectedHours();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _saveSelectedHours() {
    // feed to model.
    print('Selected Day: $selectedDay');
    print('Selected Hours: $selectedHours');
  }
}
