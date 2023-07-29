
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  int currentIndex_ = 0;
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: PageView(
        controller: controller,
        onPageChanged: (value) {
          setState(() {
            currentIndex_ = value;
          });
        },
        children: [
          Container(
            color: Colors.amber,
          ),
          Container(
            color: Colors.pinkAccent,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_activity), label: 'activities'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_rounded), label: 'leader board'),
        ],
        currentIndex: currentIndex_,
        onTap: (value) {
          setState(() {
            controller.animateToPage(value,
                duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
          });
        },
      ),
    );
  }
}
 
