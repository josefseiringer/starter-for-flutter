import 'package:flutter/material.dart';


class MyTextFormField extends StatelessWidget {
  
  final bool? readOnly;
  final TextEditingController controller;
  final String labelText;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  const MyTextFormField({
    super.key,
    this.readOnly,
    required this.controller,
    required this.labelText,
    this.onTap,
    this.onChanged,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: readOnly ?? false,
        controller: controller,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
        keyboardType: keyboardType,
        validator: validator);
  }
}
