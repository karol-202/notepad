import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:notepad/model/user.dart';

enum AuthStateMode { register, login }

enum AuthStateStatus { not_logged, logging, logged }

enum AuthStateError { network, cannot_login, data_invalid, email_exists, other }

extension AuthStateModeFold on AuthStateMode {
  T fold<T>({@required T Function() ifRegister, @required T Function() ifLogin}) {
    switch (this) {
      case AuthStateMode.register:
        return ifRegister();
      case AuthStateMode.login:
        return ifLogin();
      default:
        throw Error();
    }
  }
}

class AuthState extends Equatable {
  final User user;
  final AuthStateMode mode;
  final AuthStateStatus status;
  final AuthStateError error;
  final bool canSubmit;

  const AuthState({
    this.user,
    this.mode = AuthStateMode.login,
    this.status = AuthStateStatus.not_logged,
    this.error,
    this.canSubmit = false,
  });

  AuthState copy({
    User user,
    AuthStateMode mode,
    AuthStateStatus status,
    AuthStateError error,
    bool canSubmit
  }) =>
      AuthState(
        user: user ?? this.user,
        mode: mode ?? this.mode,
        status: status ?? this.status,
        error: error ?? this.error,
        canSubmit: canSubmit ?? this.canSubmit,
      );

  @override
  List<Object> get props => [user, mode, status, error, canSubmit];
}
