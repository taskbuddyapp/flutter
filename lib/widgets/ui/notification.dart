import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CustomNotification extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const CustomNotification({required this.child, this.backgroundColor, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Touchable(
          enableAnimation: onTap != null,
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(
              //   color: Theme.of(context).colorScheme.outline,
              //   width: 1
              // ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 0)
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: child,
            ),
          )
        ),
      ),
    );
  }
}