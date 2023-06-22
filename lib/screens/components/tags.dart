import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/body/taged_pg.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tags extends StatefulWidget {
  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  //get current User
  final current_User = FirebaseAuth.instance.currentUser!;
  //Navigte to tags
  List<String> tagId = [];
  List<String> tags = ["default", "Telecom Policy", "Network Planning"];
  String currentTag = "default";

  // Creating the tag in Fire base and store id
  Future<void> createTag(String tag) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection("Tag").add({
      'TagName': tag,
    });
    setState(() {
      tagId.add(docRef.id);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tagId', tagId); // store data - tagId
  }

  ///*
  @override
  void initState() {
    super.initState();
    getStoredTagIds();
  }

  // read stored data
  Future<void> getStoredTagIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedTagIds = prefs.getStringList('tagId');
    if (storedTagIds != null) {
      setState(() {
        tagId = storedTagIds;
      });
    }
  } // */

  // make sure tags don't repeat
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
          onChanged: ((value) async {
            setState(() {
              currentTag = value!;
            });
            if (await checkForTag(currentTag)) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return TagPage(
                    pageTitle: currentTag,
                    tagId: tagId[tags.indexOf(currentTag)]);
              }));
              print("Done");
              print(tagId); // clear this
              print(tagId.length);
              print(tags.indexOf(currentTag));
              /*SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.remove('tagId');*/
            } else if (!await checkForTag(currentTag)) {
              // create tag
              await createTag(currentTag);
              /*Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return TagPage(
                    pageTitle: currentTag,
                    tagId: tagId[tags.indexOf(currentTag)]);
              }));*/
              print(tagId); // clear this
              print(tagId.length);
            } else {
              const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ],
    );
  }
}


/*
  /*
  .then((DocumentReference docRef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tagId.add(docRef.id);
    await prefs.setStringList('tagId', tagId);
    setState(() {});
  });
   This code caused lagged results
   Future createTag(String Tag) async {
    FirebaseFirestore.instance.collection("Tag").add({
      'TagName': Tag,
    }).then((DocumentReference docRef) {
      setState(() {
        tagId.add(docRef.id);
      });
    });
  }*/

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