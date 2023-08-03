import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/components/previous_post.dart';
import 'package:firetrial/screens/components/tags.dart';
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
          //Input Section
          Column(
            children: [
              //Tags drop down
              Tags(),
              // textinput and send
              Row(

children: [
              Expanded(
                  child: SizedBox(
                height: 48,
                child: TextField(
                  controller: quest_textcontroller,
                  decoration: InputDecoration(
                    hintText: "Have a Question?",
                    hintStyle: TextStyle(
                        color: Colors.grey), // Set the hint text color to grey
                    suffixIcon: IconButton(
                      onPressed: () {
                        quest_textcontroller.clear();
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey, // Set the clear icon color to grey
                      ),
                    ),
                    fillColor: Colors.grey[
                        200], // Set the background color to a lighter shade of grey
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: false,
                ),
              )),
              SizedBox(
                width: 30,
              ),
              // Upload
              SizedBox(
                height: 48.0, // Same height as the TextField
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      postQuestion();
                      quest_textcontroller.clear();
                    });
                  },
                  child: Icon(Icons.send),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],

      ),
        ]
        )]
 )); 
 }
}
