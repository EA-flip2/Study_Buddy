import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firetrial/screens/components/post_answer.dart';
import 'package:flutter/material.dart';

class answer_page extends StatefulWidget {
  final String tagID;
  final String quest_ID;
  const answer_page({super.key, required this.tagID, required this.quest_ID});

  @override
  State<answer_page> createState() => _answer_pageState();
}

class _answer_pageState extends State<answer_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Contributions",
      )),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Tag")
                      .doc(widget.tagID)
                      .collection("Questions")
                      .doc(widget.quest_ID)
                      .collection("Answers")
                      .orderBy("Timestamp", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var doc = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: doc.length,
                        itemBuilder: (context, index) {
                          final post = doc[index];
                          //DocumentReference answer_id = FirebaseFirestore.instance.collection("Tag").doc(widget.tagID).collection("Questions").doc(widget.quest_ID);
                          return quest_contribtion(
                              answer: post['Answer'],
                              quest_Id: widget.quest_ID,
                              user: post['User'],
                              flages: List<String>.from(post['flages'] ?? []),
                              postId: widget.tagID,
                              answer_postId: post.id,
                              likes: List<String>.from(post['likes'] ?? []));
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error:${snapshot.error}'),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }) // acces subcollection from database;
              /* StreamBuilder(
         ,
                      itemBuilder: (context, index) {
                        final post = doc[index];
                        DocumentReference actual_tagId = FirebaseFirestore
                            .instance
                            .collection("Tag")
                            .doc(widget.tagId);
                        return posted_tag_quest(
                          question: post['Question'],
                          user: post['User'],
                          flages: List<String>.from(post['flages'] ?? []),
                          postId: actual_tagId.id, //
                          quest_postId: post.id,
                          likes: List<String>.from(post['likes'] ?? []),

                        );
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error:${snapshot.error}'),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),*/
              )
        ],
      ),
    );
  }
}
