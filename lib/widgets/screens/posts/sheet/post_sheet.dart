import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_only_response.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/screens/posts/post_author.dart';
import 'package:taskbuddy/widgets/screens/posts/post_description.dart';
import 'package:taskbuddy/widgets/screens/posts/post_price.dart';
import 'package:taskbuddy/widgets/screens/posts/post_title.dart';
import 'package:taskbuddy/widgets/screens/posts/sheet/post_counter.dart';
import 'package:taskbuddy/widgets/screens/posts/sheet/post_job_type.dart';
import 'package:taskbuddy/widgets/screens/posts/sheet/post_location_display.dart';
import 'package:taskbuddy/widgets/screens/posts/sheet/post_metadata.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/visual/divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostSheet extends StatelessWidget {
  final PostResultsResponse post;
  final double paddingBottom;
  final VoidCallback sendMessage;

  const PostSheet({ Key? key, required this.post, required this.paddingBottom, required this.sendMessage }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    var dividerPadding = 16.0;

    return BottomSheetBase(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        PostJobType(post: post),
        const SizedBox(height: 8),
        PostTitle(post: post, limitLines: false,),
        const SizedBox(height: 2),
        PostDescription(post: post, limitLines: false,),
        const SizedBox(height: 8),
        PostPrice(post: post),
        const SizedBox(height: 4),
        PostData(post: post),
        const SizedBox(height: 16),
        PostAuthor(post: post, rightPadding: false,),
        if (!post.user.isMe)
          const SizedBox(height: 16),
        if (!post.user.isMe)
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizing.horizontalPadding,
              ),
              child: SlimButton(
                disabled: post.endDate.isBefore(DateTime.now()) || post.status == PostStatus.RESERVED || post.status == PostStatus.CLOSED,
                type: ButtonType.outlined,
                onPressed: sendMessage,
                child: Center(
                  child: Text(
                    l10n.sendAMessage,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface)
                  )
                ),
              ),
            ),
          ),
        CustomDivider(color: Theme.of(context).colorScheme.outline, padding: dividerPadding,),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              PostCounter(count: post.impressions, text: l10n.views),
              PostCounter(count: post.likes, text: l10n.likes),
              PostCounter(count: post.shares, text: l10n.shares),
            ],
          ),
        ),
        if (!post.isRemote && post.locationLat != 1000)
          CustomDivider(color: Theme.of(context).colorScheme.outline, padding: dividerPadding,),
        if (!post.isRemote && post.locationLat != 1000)
          PostLocationDisplay(post: post),
        SizedBox(height: paddingBottom)
      ]
    );
  }
}
