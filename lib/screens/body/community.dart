import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/previous_post.dart';
import 'package:flutter/material.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  //userobject
  final currentUser = FirebaseAuth.instance.currentUser!;
  //ask a question text controller
  final quest_textcontroller = TextEditingController();
  //post Message
  void postQuestion() {
    //only post something
    if (quest_textcontroller.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("User Post").add({
        'UserEmail': currentUser.email,
        'Message': quest_textcontroller.text,
        'TimeStamp': Timestamp.now(),
        'flages': [],
        'likes': [],
      });
    }
  }

  //Drop down list for tags
  String null_select = "Tag your question";

  List<String> tags = [
    "Math",
    "English",
    "Applied",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //display
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("User Post")
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
                      return Posted_quest(
                        message: post['Message'],
                        user: post['UserEmail'],
                        postId: post.id,
                        flages: List<String>.from(post['flages'] ?? []),
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
          //text input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: quest_textcontroller,
                  decoration: InputDecoration(
                      hintText: "Have a Question ??",
                      suffixIcon: IconButton(
                        onPressed: () {
                          quest_textcontroller.clear();
                        },
                        icon: Icon(Icons.clear), //clear text
                      )),
                  obscureText: false,
                ),
              ),

              // Upload
              MaterialButton(
                onPressed: () {
                  setState(() {
                    postQuestion();
                  });
                },
                color: Colors.blue,
                child: Icon(Icons.send),
              )
            ],
          ),
        ],
      ),
    );
  }
}
