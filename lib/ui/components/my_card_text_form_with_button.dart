import 'package:flutter/material.dart';

import './my_text_form_field.dart';

class MyCardTextFormWithButton extends StatelessWidget {
  final TextEditingController controller;
  final String labelTextFormField;
  final void Function() onPressedButton;
  final String buttonText;

  const MyCardTextFormWithButton({
    super.key,
    required this.controller,
    required this.labelTextFormField,
    required this.onPressedButton,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextFormField(
            controller: controller,
            labelText: labelTextFormField,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextButton(
              onPressed: onPressedButton,
              child: Text(
                buttonText,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
