import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/settings/items/navigation.dart';
import 'package:taskbuddy/screens/settings/section.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:app_settings/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeLocales(List<Locale>? locale) {
    setState(() {}); // Force rebuild
    super.didChangeLocales(locale);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          AppLocalizations.of(context)!.settings,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      extendBodyBehindAppBar: true,
      body: ScrollbarSingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + Sizing.appbarHeight),
            SettingsSection(
              title: l10n.account,
              children: [
                SettingsNavigation(title: l10n.account, icon: Icons.person_outline, onTap: () {}),
                SettingsNavigation(title: l10n.privacy, icon: Icons.lock_outline, onTap: () {}),
                SettingsNavigation(title: l10n.security, icon: Icons.security_outlined, onTap: () {}),
              ]
            ),
            SettingsSection(
              title: l10n.application,
              children: [
                SettingsNavigation(title: l10n.appearance, icon: Icons.color_lens_outlined, onTap: () {}),
                SettingsNavigation(title: l10n.notifications, icon: Icons.notifications_outlined, onTap: () {}),
                SettingsNavigation(title: l10n.accessibility, icon: Icons.accessibility_new_outlined, onTap: () {}),
                SettingsNavigation(
                  title: l10n.language,
                  icon: Icons.translate_outlined,
                  onTap: () {
                    AppSettings.openAppSettings(type: AppSettingsType.appLocale);
                  },
                  value: Platform.localeName.split('_')[0].toUpperCase(),
                ),
              ]
            ),
            SettingsSection(
              title: l10n.social,
              children: [
                SettingsNavigation(title: l10n.friends, icon: Icons.group_outlined, onTap: () {}),
                SettingsNavigation(title: l10n.blockedUsers, icon: Icons.block_outlined, onTap: () {}),
                SettingsNavigation(title: l10n.interests, subtitle: l10n.interestsDesc, icon: Icons.interests_outlined, onTap: () {}),
              ]
            ),
            SettingsSection(
              title: l10n.other,
              children: [
                SettingsNavigation(title: l10n.openSourceLicenses, icon: Icons.code, onTap: () {}),
              ]
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}