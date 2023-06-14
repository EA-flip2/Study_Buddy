import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/text_box.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  //user Email
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _userName = TextEditingController();
  // edit field
  Future editfield(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          //save
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text('Save'),
          )
        ],
      ),
    );

    //update in db
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          //User Profile
          return ListView(
            children: [
              //profile picture
              Icon(
                Icons.person,
                size: 72,
              ),
              const SizedBox(
                height: 50,
              ),
              //email
              Text(
                currentUser.email!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              //User name
              MyTextBox(
                sectionName: userData['username'],
                onPressed: () => editfield('username'),
              )
              //posts
            ],
          );
        } else if (snapshot.hasError) {
          // if Snapshot has error
          return Center(
            child: Text('Error' + snapshot.error.toString()),
          );
        } else {
          return Center(
            //loading screen
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
/*ListView(
        children: [
          //profile picture
          Icon(
            Icons.person,
            size: 72,
          ),
          const SizedBox(
            height: 50,
          ),
          //email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          //User name
          MyTextBox(
            sectionName: 'Emma',
            text: 'Bio',
            onPressed: () => editfield("Emma"),
          )
          //posts
        ],
      ), */