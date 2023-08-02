import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/authentication/login_reg.dart';


class Auth_Page extends StatelessWidget {
  const Auth_Page({Key? key}); // Add the 'Key' type to the constructor

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //user is logged in
        if (snapshot.hasData) {
          return Navigate(); // Change 'const Navigate()' to 'Navigate()'
        } else {
          return LoginOrRegister();
        }
      },
    );
  }
}

class Navigate extends StatefulWidget {
  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Buddy'),
        actions: [
          // Add any app-specific actions to the AppBar
        ],
      ),
      body: _buildMainInterfaceContent(),
      // ... Add any other necessary components like bottom navigation bar, drawer, etc.
    );
  }

  Widget _buildMainInterfaceContent() {
    // Create the main interface content here, such as a list of subjects or courses,
    // recommended lessons, or any other educational material relevant to your app.
    // Use ListView, GridView, or other widgets to present the content in an organized manner.

    return ListView.builder(
      itemCount: 10, // Replace with the actual number of items in your content list
      itemBuilder: (context, index) {
        final subjectId = 'subject_${index + 1}';
        return ListTile(
          title: Text('Subject ${index + 1}'),
          onTap: () {
            // Code to navigate to a specific subject's details page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubjectDetailsPage(subjectId: subjectId)),
            );
          },
          // ... Add any other content-specific widgets here
        );
      },
    );
  }
}

// Add the 'SubjectDetailsPage' class definition here
class SubjectDetailsPage extends StatelessWidget {
  final String subjectId;

  SubjectDetailsPage({required this.subjectId});

  @override
  Widget build(BuildContext context) {
    // Implement the UI for displaying subject details using the subjectId
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Details'),
      ),
      body: Center(
        child: Text('Subject ID: $subjectId'),
      ),
    );
  }
}
