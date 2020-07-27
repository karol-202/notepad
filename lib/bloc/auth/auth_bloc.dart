import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/api/api_exception.dart';
import 'package:notepad/api/auth/auth_exception.dart';
import 'package:notepad/bloc/auth/auth_event.dart';
import 'package:notepad/bloc/auth/auth_state.dart';
import 'package:notepad/repository/auth/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  StreamSubscription _authDataSubscription;

  AuthBloc(this.authRepository) : super(AuthState()) {
    _listenForAuthData();
  }

  void _listenForAuthData() => _authDataSubscription = authRepository.getAuthState().listen((authData) {
        add(AuthDataUpdatedAuthEvent(authData));
      });

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SwitchModeAuthEvent)
      yield* _mapSwitchModeToState();
    else if (event is AuthDataUpdatedAuthEvent)
      yield* _mapDataUpdatedToState(event);
    else if (event is FormUpdatedAuthEvent)
      yield* _mapFormUpdatedToState(event);
    else if (event is SubmitAuthEvent)
      yield* _mapRegisterToState(event);
    else if (event is LogoutAuthEvent) yield* _mapLogoutToState();
  }

  Stream<AuthState> _mapSwitchModeToState() async* {
    yield state.copy(
      mode: state.mode == AuthStateMode.register ? AuthStateMode.login : AuthStateMode.register,
      canSubmit: false,
    );
  }

  Stream<AuthState> _mapDataUpdatedToState(AuthDataUpdatedAuthEvent event) async* {
    yield state.copy(
      status: event.authData != null ? AuthStateStatus.logged : AuthStateStatus.not_logged,
    );
  }

  Stream<AuthState> _mapFormUpdatedToState(FormUpdatedAuthEvent event) async* {
    yield state.copy(
      canSubmit: event.isValid,
    );
  }

  Stream<AuthState> _mapRegisterToState(SubmitAuthEvent event) async* {
    yield* _mapCatching(() async* {
      yield state.copy(status: AuthStateStatus.logging);
      await state.mode.fold(
        ifRegister: () => authRepository.register(event.email, event.password),
        ifLogin: () => authRepository.login(event.email, event.password),
      );
    });
  }

  Stream<AuthState> _mapCatching(Stream<AuthState> Function() operation) async* {
    final previousState = state;
    try {
      await for (var value in operation()) yield value;
    } on ApiConnectionException {
      yield* _mapErrorToState(previousState, AuthStateError.network);
    } on AuthApiCannotAuthException {
      final error = previousState.mode == AuthStateMode.register
          ? AuthStateError.data_invalid
          : AuthStateError.cannot_login;
      yield* _mapErrorToState(previousState, error);
    } on AuthApiEmailExistsException {
      yield* _mapErrorToState(previousState, AuthStateError.email_exists);
    } catch (e) {
      yield* _mapErrorToState(previousState, AuthStateError.other);
    }
  }

  Stream<AuthState> _mapErrorToState(AuthState baseState, AuthStateError error) async* {
    yield baseState.copy(error: error);
    yield baseState;
  }

  Stream<AuthState> _mapLogoutToState() async* {
    await authRepository.logout();
  }

  void dispose() {
    _authDataSubscription.cancel();
  }
}
