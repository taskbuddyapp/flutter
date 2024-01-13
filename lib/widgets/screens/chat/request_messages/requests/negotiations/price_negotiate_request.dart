import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/request_message_base.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';

class PriceNegotiateRequest extends StatefulWidget {
  final MessageResponse message;

  const PriceNegotiateRequest({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<PriceNegotiateRequest> createState() => _PriceNegotiateRequestState();
}

class _PriceNegotiateRequestState extends State<PriceNegotiateRequest> {
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

    var res = await Api.v1.channels.messages.updateMessageStatus(token, widget.message.channelUUID, widget.message.UUID, action);

    if (!res) {
      SnackbarPresets.error(context, l10n.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    var price = jsonDecode(widget.message.request!.data!)["price"];

    return RequestMessageBase(
      title: l10n.negotiatePriceMessage("€$price"),
      body: l10n.negotiatePriceDesc,
      status: widget.message.request!.status,
      actions: [
        Expanded(
          child: SlimButton(
            disabled: widget.message.sender!.isMe,
            onPressed: () {
              _sendRequest(
                context,
                title: l10n.accept,
                body: l10n.accept,
                action: 1
              );
            },
            child: ButtonText(
              l10n.accept
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SlimButton(
            disabled: widget.message.sender!.isMe,
            onPressed: () {
              _sendRequest(
                context,
                title: l10n.reject,
                body: l10n.reject,
                action: 0
              );
            },
            type: ButtonType.outlined,
            child: Text(
              l10n.reject
            ),
          ),
        ),
      ],
    );
  }
}