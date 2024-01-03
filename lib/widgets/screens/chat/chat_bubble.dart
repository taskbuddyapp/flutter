import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String profilePicture;
  final bool isMe;
  final bool showProfilePicture;
  final bool showSeen;
  final bool deleted;
  final bool seen;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    this.showProfilePicture = true,
    this.showSeen = false,
    this.profilePicture = "",
    this.deleted = false,
    this.seen = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMe ? 16 : 8, vertical: 4),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: showProfilePicture ? ProfilePictureDisplay(
                      size: 28,
                      iconSize: 14,
                      profilePicture: profilePicture
                    ) : null,
                  ),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isMe
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Text(
                    deleted ? l10n.messageDeleted : message,
                    style: TextStyle(
                      color: isMe
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          showSeen && seen && isMe ? Padding(
            padding: const EdgeInsets.only(left: 48.0, top: 4),
            child: Text(
              l10n.seen,
              style: Theme.of(context).textTheme.labelSmall
            )
          ) : Container(),
        ],
      ),
    );
  }
}