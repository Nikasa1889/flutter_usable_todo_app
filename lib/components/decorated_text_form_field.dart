import "package:flutter/material.dart";

class DecoratedTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String) validator;

  DecoratedTextFormField(
      {this.controller,
      this.prefixIcon,
      this.hintText,
      this.keyboardType,
      this.validator,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: this.obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).selectedRowColor,
        prefixIcon: Icon(prefixIcon),
      ),
      validator: validator,
    );
  }
}
