import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/request_message_base.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';

class FinishRequestMessage extends StatelessWidget {
  final MessageResponse message;
  final ChannelResponse channel;

  const FinishRequestMessage({
    Key? key,
    required this.message,
    required this.channel,
  }) : super(key: key);

  void _sendRequest(
    BuildContext context, {
      required String title,
      required String body,
      required int action
    }) async {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    // Show a confirmation dialog
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(title),
          ),
        ],
      ),
    );

    if (result == null || !result) return;

    String token = (await AccountCache.getToken())!;

    var res = await Api.v1.channels.messages.updateMessageStatus(token, message.channelUUID, message.UUID, action);

    if (!res) {
      SnackbarPresets.error(context, l10n.somethingWentWrong);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    Map<String, dynamic> data = jsonDecode(message.request!.data!);

    return RequestMessageBase(
      status: message.request!.status,
      title: l10n.jobFinished,
      body: l10n.jobFinishedDesc,
      actions: [
        Expanded(
          child: SlimButton(
            disabled: message.sender!.isMe,
            onPressed: () {
              _sendRequest(
                context,
                title: l10n.confirmJobFinished,
                body: l10n.confirmJobFinishedDesc,
                action: 1,
              );
            },
            child: ButtonText(l10n.accept),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SlimButton(
            disabled: message.sender!.isMe,
            type: ButtonType.outlined,
            onPressed: () {
              _sendRequest(
                context,
                title: l10n.rejectJobFinished,
                body: l10n.rejectJobFinishedDesc,
                action: 0,
              );
            },
            child: Text(l10n.reject),
          ),
        ),
      ],
      finishedActions: [
        if ((channel.isPostCreator && !data['left_review_by_employer']) || (!channel.isPostCreator && !data['left_review_by_employee']))
          Expanded(
            child: SlimButton(
              type: ButtonType.outlined,
              onPressed: () async {
                // Show a popup to leave a review
              },
              child: Text(l10n.leaveAReview),
            ),
        ),
      ],
    );
  }
}
