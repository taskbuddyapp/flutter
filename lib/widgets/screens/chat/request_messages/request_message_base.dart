import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestMessageBase extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String body;
  final List<Widget> actions;
  final List<Widget> finishedActions;
  final int status;

  const RequestMessageBase({
    Key? key,
    required this.title,
    this.subtitle,
    required this.body,
    this.actions = const [],
    this.finishedActions = const [],
    this.status = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status != MessageRequest.PENDING)
            Text(
              status == MessageRequest.ACCEPTED
                ? l10n.requestAccepted
                : l10n.requestRejected,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w900,
                color: status == MessageRequest.DECLINED
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary
              )
            ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              )
            ),
          const SizedBox(height: 4),
          Text(
            body,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (actions.isNotEmpty && status == MessageRequest.PENDING)
            const SizedBox(height: 16),

          if (actions.isNotEmpty && status == MessageRequest.PENDING)
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ),
            
          if (finishedActions.isNotEmpty && status == MessageRequest.ACCEPTED)
            const SizedBox(height: 16),

          if (finishedActions.isNotEmpty && status == MessageRequest.ACCEPTED)
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: finishedActions,
              ),
            ),
        ],
      ),
    );
  }
}
