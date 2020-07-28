import 'package:flutter/material.dart';

class AuthFlatIconButton extends StatelessWidget {
  final String iconAsset;
  final String text;
  final void Function() onPressed;

  AuthFlatIconButton({
    @required this.iconAsset,
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconAsset,
            width: 24,
            height: 24,
          ),
          Container(
            child: Text(text),
            margin: EdgeInsets.only(left: 16, right: 8),
          )
        ],
      ),
      onPressed: onPressed,
      textColor: primaryColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: primaryColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
    );
  }
}
