import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/flaged.dart';
import 'package:firetrial/screens/components/likebutton.dart';
import 'package:flutter/material.dart';

class posted_tag_quest extends StatefulWidget {
  final String question;
  final String user;
  final String postId; // to identify post
  final List<String> flages; // keep track of flags
  final List<String> likes;
  const posted_tag_quest({
    super.key,
    required this.question,
    required this.user,
    required this.flages,
    required this.postId,
    required this.likes,
  });

  @override
  State<posted_tag_quest> createState() => _posted_tag_questState();
}

class _posted_tag_questState extends State<posted_tag_quest> {
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
    DocumentReference postRef = FirebaseFirestore.instance
        .collection("Tag")
        .doc(widget.postId)
        .collection("Question")
        .doc(); // may require ID

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

  /// Access sub collection

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(widget.user),
            subtitle: Text(widget.question),
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
