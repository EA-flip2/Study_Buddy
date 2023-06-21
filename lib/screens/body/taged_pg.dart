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

  //Post Question
  void postTagQuestion(String tagId) async {
    //only post something
    if (taggedQuestion.text.isNotEmpty) {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection("Tag").doc(tagId);
      setState(() {
        docRef.collection("Questions").add({
          'Question': taggedQuestion.text,
          'User': current_User.email,
          'Timestamp': Timestamp.now(),
          'flages': [],
          'likes': [],
        });
      });
    }
  }

  //

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
                        return posted_tag_quest(
                            question: post['Question'],
                            user: post['User'],
                            flages: List<String>.from(post['flages'] ?? []),
                            postId: post.id,
                            likes: List<String>.from(post['likes'] ?? []));
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error:${snapshot.error}'),
                  );
                }
                return CircularProgressIndicator();
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
