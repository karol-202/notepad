import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/auth/auth_bloc.dart';
import 'package:notepad/bloc/auth/auth_state.dart';
import 'package:notepad/model/user.dart';

class AuthListener extends StatelessWidget {
  final void Function() onLogout;
  final Widget Function(User) builder;

  AuthListener({
    this.onLogout,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) => _onUpdate(state),
      builder: (_, state) => builder(state.user),
    );
  }

  void _onUpdate(AuthState state) {
    if (state.status != AuthStateStatus.logged) onLogout();
  }
}
