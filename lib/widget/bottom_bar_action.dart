import 'package:flutter/material.dart';

class BottomBarAction extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;

  BottomBarAction({
    @required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(16),
      color: Theme.of(context).primaryIconTheme.color,
      disabledColor: Theme.of(context).primaryIconTheme.color.withOpacity(0.54),
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
