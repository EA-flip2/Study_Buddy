import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/post_tag_quest.dart';
import 'package:flutter/material.dart';

class TagPage extends StatefulWidget {
  final String pageTitle;
  final String tagId;

  TagPage({
    //!!! Key?key
    Key? key,
    required this.pageTitle,
    required this.tagId,
  }) : super(key: key);

  @override
  State<TagPage> createState() => TagPageState();
}

class TagPageState extends State<TagPage> {
  final taggedQuestion = TextEditingController(); // Question placeholder
  //get current User
  final current_User = FirebaseAuth.instance.currentUser!;
  //
  String? questionId;

  //Post Question
  Future<void> postTagQuestion(String tagId) async {
    if (taggedQuestion.text.isNotEmpty) {
      DocumentReference tagDocRef =
          FirebaseFirestore.instance.collection("Tag").doc(tagId);

      DocumentReference questionDocRef =
          await tagDocRef.collection("Questions").add({
        'Question': taggedQuestion.text,
        'User': current_User.email,
        'Timestamp': Timestamp.now(),
        'flages': [],
        'likes': [],
        'TagId': '',
      });
      String? questionId = questionDocRef.id;
      setState(() {
        questionDocRef.update({'TagId': questionId});
      });
    }

    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Q & A" + "for " + widget.pageTitle),
      ),
      body: Column(
        children: [
          //Display Previous Question
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Tag")
                  .doc(widget.tagId)
                  .collection("Questions")
                  .orderBy(
                    "Timestamp",
                    descending: false,
                  )
                  .snapshots(), // acces subcollection from database;
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var doc = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: doc.length,
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
            ),
          ),

          // input Question Text
          TextField(
            controller: taggedQuestion,
            decoration: InputDecoration(
                hintText: "Have a Question",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    taggedQuestion.clear();
                  },
                )),
            obscureText: false,
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                postTagQuestion(widget.tagId);
                //post or upload question
              });
            },
            color: Colors.blue,
            child: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}


/*
  Future<void> createTag(String tag) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection("Tag").add({
      'TagName': tag,
      'TagId': '',
    });
    setState(() {
      docRef.update({'TagId': docRef.id});
    });
  }
*/
    /*void postTagQuestion(String tagId) {
    //only post something
    if (taggedQuestion.text.isNotEmpty) {
      DocumentReference docRef =
          // ignore: await_only_futures
          FirebaseFirestore.instance.collection("Tag").doc(tagId);
      setState(() {
        docRef.collection("Questions").add({
          'Question': taggedQuestion.text,
          'User': current_User.email,
          'Timestamp': Timestamp.now(),
          'flages': [],
          'likes': [],
          'TagId': '',
        });
        setState(() {
          setState(() {
            docRef.update({'TagId': docRef.id});
          });
        });
      });
    }
  }*/
    //