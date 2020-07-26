import 'package:flutter/material.dart';

class _LoginData {
  String email;
  String password;
}

class AuthModeLogin extends StatefulWidget {
  final void Function(String, String) onSubmit;
  final void Function() onModeSwitch;

  AuthModeLogin({
    @required this.onSubmit,
    @required this.onModeSwitch,
  });

  @override
  _AuthModeLoginState createState() => _AuthModeLoginState();
}

class _AuthModeLoginState extends State<AuthModeLogin> {
  final _formKey = GlobalKey<FormState>();
  final _registerData = _LoginData();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            onSaved: (value) => _registerData.email = value,
          ),
          TextFormField(
            obscureText: true,
            onSaved: (value) => _registerData.password = value,
          ),
          RaisedButton(
            child: Text("Zaloguj"),
            onPressed: _submit,
          ),
          RaisedButton(
            child: Text("Chcę założyć konto"),
            onPressed: widget.onModeSwitch,
          ),
        ],
      ),
    );
  }

  void _submit() {
    _formKey.currentState.save();
    widget.onSubmit(_registerData.email, _registerData.password);
  }
}
