import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/utils/haptic_feedback.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

// Button types
enum ButtonType { primary, outlined }

// Button component
class Button extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final ButtonType type;
  final double? width;
  final double height;
  final double radius;
  final bool loading;
  final bool disabled;

  const Button(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.width,
      this.height = 40,
      this.radius = 4,
      this.type = ButtonType.primary,
      this.disabled = false,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      disabled: loading || disabled,
      onTap: () {
        if (disabled) return;
        HapticFeedbackUtils.lightImpact(context);
        onPressed();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: type == ButtonType.primary
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 1),
            borderRadius: BorderRadius.circular(radius)),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: type == ButtonType.primary
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.primary,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}

// Button text component
// This is used to style the text inside the button
class ButtonText extends StatelessWidget {
  final String text;

  const ButtonText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    );
  }
}
