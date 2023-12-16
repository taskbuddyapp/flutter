import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class PostDescription extends StatelessWidget {
  final PostResponse post;
  final bool limitLines;

  const PostDescription({ Key? key, required this.post, this.limitLines = true, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: Sizing.horizontalPadding, right: Sizing.horizontalPadding + Sizing.interactionsWidth),
        child: Text(
          limitLines ? post.description.replaceAll("\n", " ") : post.description,
          style: Theme.of(context).textTheme.labelMedium,
          maxLines: limitLines ? 1 : null,
          overflow: limitLines ? TextOverflow.ellipsis : null,
        ),
      ),
    );
  }
}