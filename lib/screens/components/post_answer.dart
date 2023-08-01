import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/flaged.dart';
import 'package:firetrial/screens/components/likebutton.dart';
import 'package:firetrial/tools/com_controller.dart';
import 'package:flutter/material.dart';

class quest_contribtion extends StatefulWidget {
  final String answer;
  final String user;
  final String quest_Id;
  final String postId; // to identify tag
  final String answer_postId; // to identify question
  final List<String> flages; // keep track of flags
  final List<String> likes;
  const quest_contribtion({
    super.key,
    required this.answer,
    required this.user,
    required this.quest_Id,
    required this.flages,
    required this.postId,
    required this.answer_postId,
    required this.likes,
  });

  @override
  State<quest_contribtion> createState() => _quest_contribtionState();
}

class _quest_contribtionState extends State<quest_contribtion> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isflagged = false;
  bool isLiked = false;
  bool ispushed = false;
  final contibuted_answer = TextEditingController();
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
        .collection("Questions")
        .doc(widget.quest_Id)
        .collection("Answers")
        .doc(widget.answer_postId); // require ID of question doc

    if (isflagged) {
      // add user to liked field
      postRef.update({
        'flages': FieldValue.arrayUnion([currentUser.email])
      });
      reports(widget.flages.length);
    } else {
      postRef.update({
        'flages': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void togglelike() {
    setState(() {
      isLiked = !isLiked;
    });
    // access document in fire base
    DocumentReference postRef = FirebaseFirestore.instance
        .collection("Tag")
        .doc(widget.postId)
        .collection("Questions")
        .doc(widget.quest_Id)
        .collection("Answers")
        .doc(widget.answer_postId); // question id

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

  /////Answer

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(widget.user),
            subtitle: Text(widget.answer),
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
        ),
        //
      ],
    );
  }
}
