import 'package:flutter/material.dart';

class AuthRaisedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  AuthRaisedButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(text),
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
    );
  }
}
