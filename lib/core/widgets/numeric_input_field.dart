import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final double? initialValue;
  final ValueChanged<double?>? onChanged;
  final String? prefix;
  final String? suffix;
  final double? min;
  final double? max;

  const NumericInputField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            suffixText: suffix,
          ),
          onChanged: (value) {
            if (onChanged != null) {
              final parsed = double.tryParse(value);
              onChanged!(parsed);
            }
          },
        ),
      ],
    );
  }
}
