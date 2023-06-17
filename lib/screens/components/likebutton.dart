import 'package:flutter/material.dart';

class likeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;

  likeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
        color: isLiked ? Colors.blue : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
