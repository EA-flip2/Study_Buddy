import 'package:flutter/material.dart';

class flagButton extends StatelessWidget {
  final bool isflagged;
  void Function()? onTap;
  flagButton({
    super.key,
    required this.isflagged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isflagged ? Icons.flag : Icons.flag_outlined,
        color: isflagged ? Colors.red : Colors.grey,
      ),
    );
  }
}
