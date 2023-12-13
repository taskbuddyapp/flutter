import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/post_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/ui/post_card/post_card.dart';

class ProfilePosts extends StatefulWidget {
  const ProfilePosts({Key? key}) : super(key: key);

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  int _offset = 0;
  List<PostResponse> _posts = [];
  bool _loading = false;
  bool _hasMore = true;

  void _getPosts() async {
    String token = (await AccountCache.getToken())!;

    var posts = await Api.v1.accounts.meRoute.posts.get(token, offset: _offset);

    setState(() {
      _posts.addAll(posts);
      _hasMore = posts.length == 10;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        if (index == _posts.length - 1 && _hasMore) {
          _offset += 10;
          _getPosts();
        }

        return Touchable(
          onTap: () {
            Navigator.of(context).pushNamed('/post', arguments: PostScreenArguments(post: _posts[index]));
          },
          child: PostCard(post: _posts[index]),
        );
      },
    );
  }
}