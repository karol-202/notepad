import 'package:flutter/material.dart';

class AuthPasswordIconButton extends StatelessWidget {
  final bool showPassword;
  final void Function() onToggle;

  AuthPasswordIconButton({
    @required this.showPassword,
    @required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Icon(
          showPassword ? Icons.visibility : Icons.visibility_off,
          color: Colors.black45,
        ),
        borderRadius: BorderRadius.circular(48),
        onTap: onToggle,
      ),
    );
  }
}
