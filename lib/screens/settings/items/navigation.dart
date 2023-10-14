import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/settings/items/item.dart';

class SettingsNavigation extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsNavigation({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          subtitle == null
            ? Text(title, style: Theme.of(context).textTheme.bodyMedium)
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          const Spacer(),
          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}