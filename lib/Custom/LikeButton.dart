import 'package:flutter/material.dart';
import '../FirestoreObjects/FbPost.dart';
import '../SingleTone/FirebaseAdmin.dart';

class LikeButton extends StatefulWidget {
  final FbPost post;

  const LikeButton({required this.post});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    if (widget.post.id != null) {
      bool liked = await FirebaseAdmin().isPostLikedByUser(widget.post.id!);
      setState(() {
        isLiked = liked;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (widget.post.id != null) {
      if (isLiked) {
        await FirebaseAdmin().removeLikeFromPost(widget.post.id!);
      } else {
        await FirebaseAdmin().addLikeToPost(widget.post.id!);
      }
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: Icon(
        Icons.favorite,
        color: isLiked ? Colors.red : Colors.grey,
        size: 30,
      ),
    );
  }
}
