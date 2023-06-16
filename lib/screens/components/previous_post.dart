import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/flaged.dart';
import 'package:flutter/material.dart';

class Posted_quest extends StatefulWidget {
  final String message;
  final String user;
  final String postId; // to identify post
  final List<String> flages; // keep track of flags
  const Posted_quest({
    super.key,
    required this.message,
    required this.user,
    required this.flages,
    required this.postId,
  });

  @override
  State<Posted_quest> createState() => _Posted_questState();
}

class _Posted_questState extends State<Posted_quest> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isflagged = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isflagged = widget.flages.contains(currentUser.email);
  }

  // toggle flagged
  void toggleflag() {
    setState(() {
      isflagged = !isflagged;
    });
    // access document in fire base
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Post").doc(widget.postId);

    if (isflagged) {
      // add user to liked field
      postRef.update({
        'flages': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'flages': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(widget.user),
            subtitle: Text(widget.message),
            trailing: IconButton(
              icon: Icon(Icons.thumb_up_sharp),
              onPressed: () {},
            ),
          ),
        ),
        // flag button by post
        Column(
          children: [
            flagButton(isflagged: isflagged, onTap: toggleflag),
            Text(widget.flages.length.toString()),
          ],
        )
      ],
    );
  }
}

/*Row(
      children: [
        Column(
          children: [
            Text(message),
            Text(user),
          ],
        )
      ],
    ); */
