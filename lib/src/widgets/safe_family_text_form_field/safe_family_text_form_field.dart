import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SafeFamilyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLength;
  final String? labelText;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  const SafeFamilyTextFormField(
      {super.key,
      required this.controller,
      this.validator,
      this.keyboardType,
      this.obscureText = false,
      this.maxLength,
      this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText!,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        inputFormatters: inputFormatters,
        validator: (value) => validator!(value));
  }
}
