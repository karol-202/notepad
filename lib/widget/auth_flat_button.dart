import 'package:flutter/material.dart';

class AuthFlatButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  AuthFlatButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return FlatButton(
      child: Text(text),
      onPressed: onPressed,
      textColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        side: BorderSide(color: primaryColor, width: 1),
      ),
    );
  }
}
