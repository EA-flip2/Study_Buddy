import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/body/community.dart';
import 'package:firetrial/screens/body/home_pg.dart';
import 'package:flutter/material.dart';

class Navigate extends StatefulWidget {
  const Navigate({super.key});

  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              //signOut
              IconButton(
                onPressed: signOut,
                icon: Icon(Icons.logout),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                //Personal Tab
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Personal',
                ),
                //Group Tab
                Tab(
                  icon: Icon(Icons.group),
                  text: 'Group',
                ),
                //Community Tab
                Tab(
                  icon: Icon(Icons.groups_2),
                  text: 'Community',
                )
              ],
            ),
          ),
          body: TabBarView(children: [
            Personal(),
            Container(
              color: Colors.black,
            ),
            Community(),
          ]),
        ),
      ),
    );
  }
}
