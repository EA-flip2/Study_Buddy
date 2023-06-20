import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/flaged.dart';
import 'package:firetrial/screens/components/likebutton.dart';
import 'package:flutter/material.dart';

class Posted_quest extends StatefulWidget {
  final String message;
  final String user;
  final String postId; // to identify post
  final List<String> flages; // keep track of flags
  final List<String> likes;
  const Posted_quest({
    super.key,
    required this.message,
    required this.user,
    required this.flages,
    required this.postId,
    required this.likes,
  });

  @override
  State<Posted_quest> createState() => _Posted_questState();
}

class _Posted_questState extends State<Posted_quest> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isflagged = false;
  bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isflagged =
        widget.flages.contains(currentUser.email); // keepig track of users flag
    isLiked = widget.likes
        .contains(currentUser.email); // keep track of number of likes
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

  // toggle like
  void togglelike() {
    setState(() {
      isLiked = !isLiked;
    });
    // access document in fire base
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Post").doc(widget.postId);

    if (isLiked) {
      // add user to liked field
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUser.email])
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
            trailing: Column(
              children: [
                likeButton(isLiked: isLiked, onTap: togglelike),
                Text(widget.likes.length.toString()),
              ],
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
