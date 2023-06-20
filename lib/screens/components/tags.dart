import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  //Navigte to tags
  List<String> tagId = [];
  List<String> questionId = [];
  List<String> tags = ["default", "A", "B"];
  String currentTag = "default";

  // Creating the tag in Fire base and store id
  void createTag(String Tag) {
    FirebaseFirestore.instance.collection("Tag").add({
      'TagName': Tag,
    }).then((DocumentReference docRef) {
      tagId.add(docRef.id);
    });
  }

  // Add a question to a tag and storing its reference
  void addQuestion(String tagId, String question) {
    FirebaseFirestore.instance
        .collection("Tag")
        .doc(tagId)
        .collection("Question")
        .add({
      'Question': question,
    }).then((DocumentReference questionReference) {
      questionId.add(questionReference.id);
    });
  }

  Future<bool> checkForTag(String tag) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Tag")
        .where('TagName', isEqualTo: tag)
        .get();

    // Check if there is at least one matching document
    bool hasMatchingDocument = querySnapshot.size > 0;
    debugPrint(hasMatchingDocument.toString());
    return hasMatchingDocument;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Select Tag: "),
        Expanded(child: Container()),
        DropdownButton(
          value: currentTag,
          items: tags.map((String item) {
            return DropdownMenuItem(
              child: Text(item),
              value: item,
            );
          }).toList(),
          onChanged: ((value) {
            setState(() async {
              currentTag = value!;
              if (await checkForTag(currentTag)) {
                // tag is already in existance add question
              } else if (!await checkForTag(currentTag)) {
                // create tag
                createTag(currentTag);
              } else {
                const CircularProgressIndicator();
              }
            });
          }),
        ),
      ],
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nested List to Firestore'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => saveNestedList(),
            child: Text('Save Nested List'),
          ),
        ),
      ),
    );
  }

  void saveNestedList() {
    List<List<String>> nestedList = [
      ['Apple', 'Banana', 'Cherry'],
      ['Dog', 'Cat', 'Elephant'],
      ['Red', 'Green', 'Blue']
    ];

    List<List<dynamic>> firestoreList = nestedList.map((list) => list.cast<dynamic>()).toList();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference docRef = firestore.collection('your_collection').doc('your_document');

    docRef.set({
      'nestedListField': firestoreList,
    }).then((_) {
      print('Nested list saved to Firestore successfully!');
    }).catchError((error) {
      print('Failed to save nested list to Firestore: $error');
    });
  }
}

*/