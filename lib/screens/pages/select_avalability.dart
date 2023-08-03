import 'package:flutter/material.dart';

class week_avalability extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Grid of Hours')),
        body: GridOfHours(),
      ),
    );
  }
}

class GridOfHours extends StatefulWidget {
  @override
  _GridOfHoursState createState() => _GridOfHoursState();
}

class _GridOfHoursState extends State<GridOfHours> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  Map<String, List<int>> selectedHours = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: daysOfWeek.length + 1,
      itemBuilder: (context, index) {
        if (index == daysOfWeek.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _submitSelection,
              child: Text('Submit'),
            ),
          );
        }

        String day = daysOfWeek[index];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 12,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: 24,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, hourIndex) {
                    final bool isSelected = selectedHours.containsKey(day) &&
                        selectedHours[day]!.contains(hourIndex + 1);
                    return GestureDetector(
                      onTap: () => toggleHourSelection(day, hourIndex + 1),
                      child: GridTile(
                        child: Container(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          child: Center(child: Text('${hourIndex + 1}')),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void toggleHourSelection(String day, int hour) {
    setState(() {
      if (selectedHours.containsKey(day)) {
        if (selectedHours[day]!.contains(hour)) {
          selectedHours[day]!.remove(hour);
        } else {
          selectedHours[day]!.add(hour);
        }
      } else {
        selectedHours[day] = [hour];
      }
    });
  }

  Map<String, List<int>> _submitSelection() {
    print(selectedHours);
    return selectedHours;
  }
}
