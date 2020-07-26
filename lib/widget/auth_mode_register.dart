import 'package:flutter/material.dart';

class _RegisterData {
  String email;
  String password;
}

class AuthModeRegister extends StatefulWidget {
  final bool canSubmit;
  final void Function(bool) onChange;
  final void Function(String, String) onSubmit;
  final void Function() onModeSwitch;

  AuthModeRegister({
    @required this.canSubmit,
    @required this.onChange,
    @required this.onSubmit,
    @required this.onModeSwitch,
  });

  @override
  _AuthModeRegisterState createState() => _AuthModeRegisterState();
}

class _AuthModeRegisterState extends State<AuthModeRegister> {
  final _formKey = GlobalKey<FormState>();
  final _registerData = _RegisterData();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _onChange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            validator: _validateEmail,
            onSaved: (value) => _registerData.email = value,
          ),
          TextFormField(
            obscureText: true,
            validator: _validatePassword,
            onSaved: (value) => _registerData.password = value,
          ),
          RaisedButton(
            child: Text("Zarejestruj"),
            onPressed: widget.canSubmit ? _submit : null,
          ),
          RaisedButton(
            child: Text("Mam już konto"),
            onPressed: widget.onModeSwitch,
          ),
        ],
      ),
    );
  }

  String _validateEmail(String value) {
    if (!value.contains('@')) return 'Email nieprawidłowy';
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 6) return 'Hasło za krótkie';
    return null;
  }

  void _onChange() {
    final isValid = _formKey.currentState.validate();
    widget.onChange(isValid);
  }

  void _submit() {
    _formKey.currentState.save();
    widget.onSubmit(_registerData.email, _registerData.password);
  }
}
