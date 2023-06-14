import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox({
    super.key,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child:
          //Section name
          Row(
        children: [
          Text(sectionName),
          //edit button
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.edit,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }
}
