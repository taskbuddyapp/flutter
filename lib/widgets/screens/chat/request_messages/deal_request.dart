import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/request_message_base.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DealRequestMessage extends StatelessWidget {
  final int status;

  const DealRequestMessage({ Key? key, required this.status }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return RequestMessageBase(
      title: l10n.iChooseYou,
      body: l10n.iChooseYouDesc,
      actions: [
        Expanded(
          child: SlimButton(
            onPressed: () {},
            child: ButtonText(l10n.accept),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SlimButton(
            type: ButtonType.outlined,
            onPressed: () {},
            child: Text(l10n.reject),
          ),
        ),
      ]
    );
  }
}