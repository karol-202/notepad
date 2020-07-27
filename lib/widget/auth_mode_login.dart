import 'package:flutter/material.dart';
import 'package:notepad/widget/auth_flat_button.dart';
import 'package:notepad/widget/auth_header_text.dart';
import 'package:notepad/widget/auth_mode_base.dart';
import 'package:notepad/widget/auth_password_icon_button.dart';
import 'package:notepad/widget/auth_raised_button.dart';
import 'package:notepad/widget/auth_text_form_field.dart';

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

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuthModeBase(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AuthHeaderText("Logowanie"),
            SizedBox(height: 20),
            AuthTextFormField(
              onSaved: (value) => _registerData.email = value,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24),
            AuthTextFormField(
              onSaved: (value) => _registerData.password = value,
              obscureText: _showPassword,
              hintText: 'Hasło',
              suffixIcon: AuthPasswordIconButton(
                showPassword: _showPassword,
                onToggle: _togglePasswordVisibility,
              ),
            ),
            SizedBox(height: 16),
            AuthRaisedButton(
              text: "ZALOGUJ",
              onPressed: _submit,
            ),
            SizedBox(height: 8),
            AuthFlatButton(
              text: "CHCĘ ZAŁOŻYĆ KONTO",
              onPressed: widget.onModeSwitch,
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordVisibility() =>
      setState(() => _showPassword = !_showPassword);

  void _submit() {
    _formKey.currentState.save();
    widget.onSubmit(_registerData.email, _registerData.password);
  }
}
