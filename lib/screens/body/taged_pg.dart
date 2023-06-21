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
  List<String> questionId = [];
  //
  void addQuestion(String tagId, String question) {
    FirebaseFirestore.instance
        .collection("Tag")
        .doc(tagId)
        .collection("Question")
        .add({
      'Question': question,
    }).then((DocumentReference questionReference) {
      setState(() {
        questionId.add(questionReference.id);
      });
    });
  }

  //Post Question
  void post_tagged_quest(String docId) {
    // dont post empty question
    if (taggedQuestion.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("Tag")
          .doc(docId)
          .collection("Question")
          .add({
        'User': current_User.email,
        'Question': taggedQuestion.text,
        'Timestomp': Timestamp.now(),
        'flages': [],
        'likes': [],
      });
    }
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
                .doc()
                .collection("Question")
                .orderBy(
                  "TimeStamp",
                  descending: false,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //get msg
                      final post = snapshot.data!.docs[index];
                      return posted_tag_quest(
                        question: taggedQuestion.text,
                        user: post['Question'],
                        flages: List<String>.from(post['flages'] ?? []),
                        postId: post.id,
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
          )),

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
                post_tagged_quest(widget.tagId);
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
