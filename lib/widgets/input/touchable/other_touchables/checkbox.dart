import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

// Checkbox component with a label
class TBCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final Widget child;
  final MainAxisAlignment mainAxisAlignment;

  const TBCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.child,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable( // Listen to tap events
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Container( // Checkbox style
            decoration: BoxDecoration(
              color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.background,
              border: Border.all(
                color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            width: 20,
            height: 20,
            child: value
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 16,
                  )
                : null,
          ),
          const SizedBox( // Spacing
            width: 16,
          ),
          Expanded(child: child), // Label, takes up the remaining space
        ],
      ),
    );
  }
}
