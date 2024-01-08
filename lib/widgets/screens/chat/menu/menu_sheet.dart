import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/screens/chat/menu/sheet_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/screens/chat/menu/sheet_divider.dart';

class MenuSheet extends StatelessWidget {
  final ChannelResponse channel;
  final Function(MessageResponse) onMessage;

  const MenuSheet({Key? key, required this.channel, required this.onMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    var padding = MediaQuery.of(context).padding;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: BlurParent(
        blurColor: Theme.of(context).colorScheme.background.withOpacity(0.75),
        noBlurColor: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: padding.top),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SheetAction(
                onPressed: () {},
                label: l10n.media,
                icon: Icons.image_outlined,
              ),
              SheetAction(
                onPressed: () {},
                label: l10n.files,
                icon: Icons.insert_drive_file_outlined,
              ),
              if (channel.isPostCreator)
                SheetDivider(label: l10n.employerOptions),
              if (channel.isPostCreator && channel.status == ChannelStatus.PENDING)
                SheetAction(
                  onPressed: () async {
                    LoadingOverlay.showLoader(context);

                    String token = (await AccountCache.getToken())!;

                    var res = await Api.v1.channels.actions.manageWorker(
                      token,
                      channel.uuid,
                      true
                    );

                    if (res.ok) {
                      onMessage(res.data!);
                    }

                    LoadingOverlay.hideLoader(context);
                  },
                  label: l10n.chooseEmployee,
                  icon: Icons.check
                ),
              if (channel.isPostCreator && channel.status == ChannelStatus.PENDING)
                SheetAction(
                  onPressed: () {},
                  label: l10n.rejectEmployee,
                  icon: Icons.close
                ),
              if (channel.isPostCreator)
                SheetAction(
                  onPressed: () {},
                  label: l10n.sharePostLocation,
                  icon: Icons.location_on_outlined,
                ),
              SheetDivider(label: l10n.jobOptions),
              SheetAction(
                onPressed: () {
                },
                label: l10n.negotiatePrice,
                icon: Icons.attach_money_outlined,
              ),
              SheetAction(
                onPressed: () {},
                label: l10n.changeDate,
                icon: Icons.calendar_today_outlined,
              ),
              if (channel.status == ChannelStatus.ACCEPTED)
                SheetAction(
                  onPressed: () {},
                  label: l10n.cancelJob,
                  icon: Icons.close,
                ),
              if (channel.status == ChannelStatus.ACCEPTED && !channel.isPostCreator)
                SheetAction(
                  onPressed: () {},
                  label: l10n.completeJob,
                  icon: Icons.check,
                ),
        
              SizedBox(height: padding.bottom + 16),
            ],
          ),
        )
      ),
    );
  }
}