import 'package:flutter/material.dart';

class Posted_quest extends StatelessWidget {
  final String message;
  final String user;
  const Posted_quest({
    super.key,
    required this.message,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(user),
            subtitle: Text(message),
            trailing: IconButton(
              icon: Icon(Icons.thumb_up_sharp),
              onPressed: () {},
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.flag,
            color: Colors.red,
          ),
        )
      ],
    );
  }
}


/*Row(
      children: [
        Column(
          children: [
            Text(message),
            Text(user),
          ],
        )
      ],
    ); */