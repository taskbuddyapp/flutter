import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final double borderRadius;
  final String? Function(String?) validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  const TextInput(
      {Key? key,
      required this.label,
      required this.hint,
      this.obscureText = false,
      this.borderRadius = 4,
      this.controller,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            hintText: hint,
            isDense: true,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
