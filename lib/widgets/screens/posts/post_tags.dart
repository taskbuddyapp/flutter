import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/widgets/ui/tag_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostTags extends StatelessWidget {
  final PostResultsResponse post;

  const PostTags({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Consumer<TagModel>(
      builder: (ctx, value, child) {
        if (value.isLoading) {
          return const CrossPlatformLoader();
        }

        var len = post.tags.length + (post.isUrgent ? 1 : 0);

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: len,
            itemBuilder: (context, index) {
              if (index == 0 && post.isUrgent) {
                return Row(
                  children: [
                    const SizedBox(width: Sizing.horizontalPadding),
                    TagWidget(
                      transparent: true,
                      onSelect: (s) {},
                      isSelectable: false,
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 18,
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.urgentText,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground
                            )
                          ),
                        ],
                      )
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              }

              // Check if tag id exists

              for (var tag in value.tags) {
                if (tag.id == post.tags[index - (post.isUrgent ? 1 : 0)]) {
                  return Row(
                    children: [
                      if (index == 0)
                        const SizedBox(width: Sizing.horizontalPadding),
                    
                      TagWidget(
                        transparent: true,
                        tag: tag,
                        onSelect: (s) {},
                        isSelectable: false,
                      ),

                      if (index == len - 1) 
                        const SizedBox(width: Sizing.horizontalPadding + Sizing.interactionsWidth),
                      if (index != len - 1)
                        const SizedBox(width: 8),
                    ],
                  );
                }
              }

              return Container();
            }
          ),
        ); 
      }
    );
  }
}