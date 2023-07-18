import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class Event {
  final Color color;
  final String title;

  const Event({required this.color, required this.title});
}

class _PersonalState extends State<Personal> with TickerProviderStateMixin {
  int currentIndex = 0;
  final PageController controller = PageController();
  late TabController tabController;

  final List<Event> events = [
    Event(color: Colors.blue, title: 'Upcoming Events Calendar'),
    Event(color: Colors.red, title: 'Pending Events'),
    Event(color: Colors.green, title: 'Missed Events'),
    Event(color: Colors.yellow, title: 'Ongoing Events'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: events.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        children: [
          Container(color: Colors.amber),
          Container(color: Colors.pinkAccent)
          Container(color: Colors.orange),
        ],
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
        child: Icon(Icons.add),
      ),
      endDrawer: TabBarView(
        controller: tabController,
        children: events.map((event) {
          return Container(
            color: event.color,
            child: Center(
              child: Text(event.title),
            ),
          );
        }).toList(),
      ),
    );
  }
}
