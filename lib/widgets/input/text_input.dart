import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';

class TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final double borderRadius;
  final String? Function(String?) validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String? errorText;
  final String? tooltipText;
  final bool optional; // If true, shows grey optional text
  final void Function(String)? onChanged;

  const TextInput(
      {Key? key,
      required this.label,
      required this.hint,
      this.obscureText = false,
      this.borderRadius = 4,
      this.controller,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.errorText,
      this.optional = false,
      this.onChanged,
      this.tooltipText,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('$label ', style: Theme.of(context).textTheme.titleMedium),
            if (optional)
              Text(
                '${AppLocalizations.of(context)!.optional} ',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )
              ),
            if (tooltipText != null)
              Tooltip(
                message: tooltipText,
                key: _tooltipKey,
                child: Touchable(
                  onTap: () {
                    _tooltipKey.currentState?.ensureTooltipVisible();
                  },
                  child: Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          controller: controller,
          validator: validator,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 14,
          ),
          obscureText: obscureText,
          decoration: InputDecoration(
            errorText: errorText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            hintText: hint,
            isDense: true,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
