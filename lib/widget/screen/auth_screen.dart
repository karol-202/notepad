import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/auth/auth_bloc.dart';
import 'package:notepad/bloc/auth/auth_event.dart';
import 'package:notepad/bloc/auth/auth_state.dart';
import 'package:notepad/widget/auth_mode_login.dart';
import 'package:notepad/widget/auth_mode_register.dart';
import 'package:notepad/widget/screen/notes_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AuthScreen extends StatefulWidget {
  static const ROUTE = "/auth";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  ProgressDialog _progressDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _onAuthStateChange,
        builder: (context, authState) => authState.mode.fold(
          ifRegister: () => AuthModeRegister(
            canSubmit: authState.canSubmit,
            onChange: _validate,
            onSubmit: _submit,
            onModeSwitch: _onModeSwitch,
          ),
          ifLogin: () => AuthModeLogin(
            onSubmit: _submit,
            onThirdPartyLogin: _loginWithThirdParty,
            onModeSwitch: _onModeSwitch,
          ),
        ),
      ),
    );
  }

  void _validate(bool isValid) => context.bloc<AuthBloc>().add(FormUpdatedAuthEvent(isValid));

  void _submit(String email, String password) =>
      context.bloc<AuthBloc>().add(SubmitAuthEvent(email, password));

  void _loginWithThirdParty(ThirdPartyLoginProvider provider) =>
      context.bloc<AuthBloc>().add(ThirdPartyLoginAuthEvent(provider));

  void _onModeSwitch() => context.bloc<AuthBloc>().add(SwitchModeAuthEvent());

  void _onAuthStateChange(BuildContext context, AuthState authState) {
    if (authState.error != null) _showFailureSnackbar(context, authState.error);

    switch (authState.status) {
      case AuthStateStatus.not_logged:
        _hideProgressDialogIfVisible();
        break;
      case AuthStateStatus.logging:
        _showProgressDialog(context, authState.mode);
        break;
      case AuthStateStatus.logged:
        Navigator.pushNamed(context, NotesScreen.ROUTE);
        break;
    }
  }

  Future<void> _showProgressDialog(BuildContext context, AuthStateMode mode) async {
    final dialog = _progressDialog = ProgressDialog(context)
      ..style(
        message: mode.fold(ifRegister: () => 'Rejestrowanie', ifLogin: () => 'Logowanie'),
        progressWidget: Container(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      );
    await dialog.show();
    if (_progressDialog == null) // _hideProgressDialogIfVisible has been called in meanwhile
      dialog.hide();
  }

  void _hideProgressDialogIfVisible() {
    _progressDialog?.hide();
    _progressDialog = null;
  }

  void _showFailureSnackbar(BuildContext context, AuthStateError error) {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(_getNotesErrorText(error)),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _getNotesErrorText(AuthStateError error) {
    switch (error) {
      case AuthStateError.network:
        return "Błąd połączenia";
      case AuthStateError.data_invalid:
        return "Dane nieprawidłowe";
      case AuthStateError.cannot_login:
        return "Nie można zalogować";
      case AuthStateError.email_exists:
        return "Konto o podanym adresie już istnieje";
      case AuthStateError.other:
        return "Nieznany błąd";
    }
  }
}
