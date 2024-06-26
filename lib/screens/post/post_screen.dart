import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/screens/posts/post.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostScreenArguments {
  final PostResultsResponse post;
  final Function(PostResultsResponse)? onUpdate;

  PostScreenArguments({ required this.post, this.onUpdate });
}

class PostScreen extends StatelessWidget {
  const PostScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PostScreenArguments;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(AppLocalizations.of(context)!.postTitle),
        transparent: true
      ),
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: PostLayout(
          post: args.post,
          onUpdate: args.onUpdate,
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }
}