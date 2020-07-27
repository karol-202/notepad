import 'package:flutter/material.dart';

class AuthTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget suffixIcon;

  AuthTextFormField({
    this.controller,
    this.validator,
    this.onSaved,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 20),
        contentPadding: EdgeInsets.only(left: 32),
        filled: true,
        fillColor: Color.fromRGBO(0, 0, 0, 0.2),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
