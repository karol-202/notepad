import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/widget/auth_flat_button.dart';
import 'package:notepad/widget/auth_header_text.dart';
import 'package:notepad/widget/auth_mode_base.dart';
import 'package:notepad/widget/auth_raised_button.dart';
import 'package:notepad/widget/auth_password_icon_button.dart';
import 'package:notepad/widget/auth_text_form_field.dart';

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
  final _passwordController = TextEditingController();
  final _registerData = _RegisterData();

  bool _showPassword = false;
  bool _policyAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _onChange,
      child: AuthModeBase(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeaderText("Rejestracja"),
            SizedBox(height: 20),
            AuthTextFormField(
              validator: _validateEmail,
              onSaved: (value) => _registerData.email = value,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24),
            AuthTextFormField(
              controller: _passwordController,
              validator: _validatePassword,
              onSaved: (value) => _registerData.password = value,
              hintText: 'Hasło',
              obscureText: !_showPassword,
              suffixIcon: AuthPasswordIconButton(
                showPassword: _showPassword,
                onToggle: _togglePasswordVisibility,
              ),
            ),
            SizedBox(height: 24),
            AuthTextFormField(
              validator: _validateConfirmedPassword,
              hintText: 'Powtórz hasło',
              obscureText: !_showPassword,
              suffixIcon: AuthPasswordIconButton(
                showPassword: _showPassword,
                onToggle: _togglePasswordVisibility,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _policyAccepted,
                  onChanged: _setPolicyAccepted,
                ),
                Text("Akceptuję regulamin"),
              ],
            ),
            SizedBox(height: 12),
            AuthRaisedButton(
              text: "ZAREJESTRUJ",
              onPressed: widget.canSubmit ? _submit : null,
            ),
            SizedBox(height: 8),
            AuthFlatButton(
              text: "MAM JUŻ KONTO",
              onPressed: widget.onModeSwitch,
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordVisibility() =>
      setState(() => _showPassword = !_showPassword);

  void _setPolicyAccepted(bool accepted) =>
      setState(() => _policyAccepted = accepted);

  String _validateEmail(String value) {
    if (!value.contains('@')) return 'Email nieprawidłowy';
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 6) return 'Hasło za krótkie';
    return null;
  }

  String _validateConfirmedPassword(String value) {
    if (value != _passwordController.text) return 'Hasło nie zgadza się';
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
