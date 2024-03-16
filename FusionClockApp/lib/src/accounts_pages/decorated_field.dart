import 'package:flutter/material.dart';

class DecoratedField extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final MaterialColor themeColor;
  final bool obscureText;
  final TextEditingController? controller;

  const DecoratedField(
      {super.key,
      this.text,
      this.themeColor = Colors.pink,
      this.icon,
      this.obscureText = false,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: text,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
          fillColor: themeColor.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(icon)),
    );
  }
}
