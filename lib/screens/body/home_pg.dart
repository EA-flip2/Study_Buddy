
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class Event {
  final Color color;
  final String title;
  static List<String> eventsList = ['Upcoming Events Calendar', 'Pending Events', 'Missed Events', 'Ongoing Events'];
  Event({required this.color, required this.title});
}

class _PersonalState extends State<Personal> with TickerProviderStateMixin {
  int currentIndex = 0;
  final PageController controller = PageController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: Event.eventsList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
        bottom: TabBar(
          controller: tabController,
          tabs: Event.eventsList.map((event) {
            return Tab(
              text: event,
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: Event.eventsList.map((event) {
          return Container(
            color: Colors.amber, // Change this color to the color property of your Event object if needed.
            child: Center(
              child: Text(event),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.task_alt_sharp),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    super.dispose();
  }
}

