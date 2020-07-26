import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/auth/auth_bloc.dart';
import 'package:notepad/bloc/auth/auth_state.dart';

class AuthListener extends StatelessWidget {
  final void Function() onLogout;
  final Widget child;

  AuthListener({
    @required this.onLogout,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (_, state) => _onUpdate(state),
      child: child,
    );
  }

  void _onUpdate(AuthState state) {
    if (state.status != AuthStateStatus.logged) onLogout();
  }
}
