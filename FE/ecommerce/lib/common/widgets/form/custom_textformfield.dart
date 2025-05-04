import 'package:flutter/material.dart';

class CTextFormField extends StatelessWidget {
  const CTextFormField({
    super.key,
    this.label = '',
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.onChanged,
    required this.controller
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
    );
  }
}