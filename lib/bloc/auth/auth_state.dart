import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
  final AuthStateMode mode;
  final AuthStateStatus status;
  final AuthStateError error;
  final bool canSubmit;

  const AuthState({
    this.mode = AuthStateMode.register,
    this.status = AuthStateStatus.not_logged,
    this.error,
    this.canSubmit = false,
  });

  AuthState copy({
    AuthStateMode mode,
    AuthStateStatus status,
    AuthStateError error,
    bool canSubmit
  }) =>
      AuthState(
        mode: mode ?? this.mode,
        status: status ?? this.status,
        error: error ?? this.error,
        canSubmit: canSubmit ?? this.canSubmit,
      );

  @override
  List<Object> get props => [mode, status, error, canSubmit];

  @override
  String toString() => "$mode $status $error $canSubmit";
}
