import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/answers.dart';
import 'package:firetrial/screens/components/flaged.dart';
import 'package:firetrial/screens/components/likebutton.dart';
import 'package:firetrial/tools/com_controller.dart';
import 'package:flutter/material.dart';

class posted_tag_quest extends StatefulWidget {
  final String question;
  final String user;
  final String postId; // to identify tag
  final String quest_postId; // to identify question
  final List<String> flages; // keep track of flags
  final List<String> likes;
  const posted_tag_quest({
    super.key,
    required this.question,
    required this.user,
    required this.flages,
    required this.postId,
    required this.quest_postId,
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
        .doc(widget.quest_postId); // require ID of question doc

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
        .doc(widget.quest_postId); // question id

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
  Future<void> answer() async {
    DocumentReference answer = FirebaseFirestore.instance
        .collection("Tag")
        .doc(widget.postId)
        .collection("Questions")
        .doc(widget.quest_postId);

    DocumentReference kk = await answer.collection("Answers").add({
      'Answer': contibuted_answer.text,
      'User': widget.user,
      'Timestamp': Timestamp.now(),
      'flages': [],
      'likes': [],
      'TagId': '',
    });
    String? AnswerId = kk.id;
    setState(() {
      kk.update({'TagId': AnswerId});
    });
  }

  ///
  // toggle like
  /*void togglelike() {
    setState(() {
      isLiked = !isLiked;
    });
    // access document in fire base
    DocumentReference postRef = FirebaseFirestore.instance
        .collection("Tag")
        .doc(widget.postId)
        .collection("Questions")
        .doc(widget.quest_postId); // question id

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
  }*/

  /// Access sub collection

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
            ),
            // addind a dropdown text field for answers
            IconButton(
              onPressed: () {
                setState(() {
                  ispushed = !ispushed;
                });
              },
              icon:
                  Icon(ispushed ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            )
            //
          ],
        ),
        if (ispushed)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: contibuted_answer,
                    decoration: InputDecoration(
                      hintText: 'Contribution',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    setState(() {
                      answer();
                    });
                  },
                  icon: const Icon(Icons.send)), //update answer collection
              IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return answer_page(
                            tagID: widget.postId,
                            quest_ID: widget.quest_postId);
                      }));
                    });
                  },
                  icon: const Icon(
                      Icons.message)), //open page showing all answers
            ],
          ),
      ],
    );
  }
}
