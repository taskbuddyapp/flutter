import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/screens/profile/profile_layout.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskbuddy/api/options.dart';

class ProfileAppbar extends StatefulWidget {
  const ProfileAppbar({Key? key}) : super(key: key);

  @override
  State<ProfileAppbar> createState() => _ProfileAppbarState();
}

class _ProfileAppbarState extends State<ProfileAppbar> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Consumer<AuthModel>(
      builder: (context, auth, child) => SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  '@${auth.username}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (auth.isPrivate) const _PrivateProfileIcon()
              ],
            ),
            const Spacer(),
            Touchable(
              child: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onTap: () {
                // Show the bottom modal with options
                CrossPlatformBottomSheet.showModal(context, [
                  // Settings
                  BottomSheetButton(
                    title: l10n.settings,
                    icon: Icons.settings,
                    onTap: (v) {
                      Navigator.of(context).pushNamed('/settings');
                    }
                  ),

                  // Support
                  // BottomSheetButton(
                  //   title: l10n.helpAndSupport,
                  //   icon: Icons.help_outline,
                  //   onTap: (v) {
                  //   }
                  // ),

                  // Saved
                  BottomSheetButton(
                    title: l10n.saved,
                    icon: Icons.bookmark_border,
                    onTap: (v) {
                      Navigator.of(context).pushNamed('/bookmarks');
                    }
                  ),

                  // History
                  // BottomSheetButton(
                  //   title: l10n.history,
                  //   icon: Icons.history,
                  //   onTap: (v) {
                  //   }
                  // ),

                  // Share
                  BottomSheetButton(
                    title: l10n.shareProfile,
                    icon: Icons.share,
                    onTap: (v) {
                      Share.share('${ApiOptions.fullDomain}/profiles/@${auth.username}');
                    }
                  ),
                ]);
              },
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(
      builder: (context, auth, child) {
        return ProfileLayout(
          fullName: auth.fullName,
          profilePicture: auth.profilePicture,
          followers: Utils.formatNumber(auth.followers),
          following: Utils.formatNumber(auth.following),
          listings: Utils.formatNumber(auth.listings),
          jobsDone: Utils.formatNumber(auth.jobsDone),
          username: auth.username,
          bio: auth.bio,
          employerRating: auth.employerRating,
          employerCancelRate: auth.employerCancelled > 0 && auth.completedEmployer == 0 
            ? 100
            : auth.employerCancelled > 0 && auth.completedEmployer > 0
              ? (auth.employerCancelled / auth.completedEmployer) * 100
              : 0,
          employeeRating: auth.employeeRating,
          employeeCancelRate: auth.employeeCancelled > 0 && auth.completedEmployee == 0 
            ? 100
            : auth.employeeCancelled > 0 && auth.completedEmployee > 0
              ? (auth.employeeCancelled / auth.completedEmployee) * 100
              : 0,
          isMe: true,
          locationText: auth.locationText,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
              child: SlimButton(
                type: ButtonType.outlined,
                child: Text(AppLocalizations.of(context)!.editProfile),
                onPressed: () {
                  Navigator.of(context).pushNamed('/profile/edit');
                },
              ),
            )
          ]
        );
      },
    );
  }
}

class _PrivateProfileIcon extends StatelessWidget {
  const _PrivateProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 4,
        ),
        Icon(
          Icons.lock_outline,
          size: 16,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ],
    );
  }
}
