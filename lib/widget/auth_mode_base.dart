import 'package:flutter/material.dart';

class AuthModeBase extends StatelessWidget {
  final Widget child;

  AuthModeBase({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.2, -1.0),
          end: Alignment(0.2, 1.0),
          colors: [Theme.of(context).primaryColorLight, Theme.of(context).primaryColorDark],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
