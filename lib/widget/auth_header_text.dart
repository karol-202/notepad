import 'package:flutter/material.dart';

class AuthHeaderText extends StatelessWidget {
  final String text;

  AuthHeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headline4
          .copyWith(fontWeight: FontWeight.w300),
    );
  }
}
