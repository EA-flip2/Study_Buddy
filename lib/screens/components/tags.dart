import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetrial/screens/pages/taged_pg.dart';
import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final current_User = FirebaseAuth.instance.currentUser!;
  List<String> tags = ["default", "Telecom Policy", "Network Planning"];
  String currentTag = "default";

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

  Future<String?> getTagId(String tagName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Tag')
        .where('TagName', isEqualTo: tagName)
        .get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      String tagId = documentSnapshot.get('TagId');
      return tagId;
    } else {
      return null;
    }
  }

  Future<bool> checkForTag(String tag) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Tag")
        .where('TagName', isEqualTo: tag)
        .get();

    return querySnapshot.size > 0;
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
          onChanged: (value) async {
            setState(() {
              currentTag = value!;
            });
            String tagId = await getTagId(currentTag) ?? "Error";
            if (await checkForTag(currentTag)) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return /*Tag_P(
                    text: currentTag,
                    tagId: tagId,
                  ); */
                      TagPage(pageTitle: currentTag, tagId: tagId);
                },
              ));
            } else {
              await createTag(currentTag);
            }
          },
        ),
      ],
    );
  }
}

class Tag_P extends StatelessWidget {
  final String text;
  final String? tagId;

  const Tag_P({
    Key? key,
    required this.text,
    required this.tagId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: Center(
        child: Column(
          children: [
            Text(tagId ?? 'No tag ID found'),
          ],
        ),
      ),
    );
  }
}
