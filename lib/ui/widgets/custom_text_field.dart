import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: controller,
      placeholder: Text(hintText),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
