import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/preferences.dart';

// A widget that blurs the background of its child
class BlurParent extends StatefulWidget {
  final Widget child;
  final double? height;
  final bool forceDisableBlur;
  final Color? blurColor;
  final Color? noBlurColor;

  const BlurParent({
    this.forceDisableBlur = false,
    required this.child,
    this.height,
    this.blurColor,
    this.noBlurColor,
    Key? key
  }) : super(key: key);

  @override
  State<BlurParent> createState() => _BlurParentState();
}

// The state of the blur parent
class _BlurParentState extends State<BlurParent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Consumer<PreferencesModel>(
        builder: (context, prefs, child) {
          var noBlurChild = Container(
            decoration: BoxDecoration(
              color: widget.noBlurColor ?? Theme.of(context).colorScheme.surface,
            ),
            child: widget.child,
          );

          if (widget.forceDisableBlur) {
            return noBlurChild;
          }

          if (!prefs.uiBlurEnabled) {
            return noBlurChild;
          }

          // assume blur is disabled
          if (child == null) {
            return noBlurChild;
          }

          return child;
        },

        // The child is with blur
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                color: widget.blurColor ?? Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: widget.child,
            ),
          ),
        ),
      )
    );
  }
}