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
        contentPadding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
        filled: true,
        fillColor: Theme.of(context).selectedRowColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            )),
        prefixIcon: Icon(prefixIcon),
      ),
      validator: validator,
    );
  }
}
