import 'package:equatable/equatable.dart';
import 'package:notepad/model/user.dart';

enum ThirdPartyLoginProvider { google }

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SwitchModeAuthEvent extends AuthEvent {
  const SwitchModeAuthEvent();

  @override
  List<Object> get props => [];
}

class AuthDataUpdatedAuthEvent extends AuthEvent {
  final User authData;

  const AuthDataUpdatedAuthEvent(this.authData);

  @override
  List<Object> get props => [authData];
}

class FormUpdatedAuthEvent extends AuthEvent {
  final bool isValid;

  const FormUpdatedAuthEvent(this.isValid);

  @override
  List<Object> get props => [isValid];
}

class SubmitAuthEvent extends AuthEvent {
  final String email;
  final String password;

  const SubmitAuthEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class ThirdPartyLoginAuthEvent extends AuthEvent {
  final ThirdPartyLoginProvider provider;

  const ThirdPartyLoginAuthEvent(this.provider);

  @override
  List<Object> get props => [provider];
}

class LogoutAuthEvent extends AuthEvent {
  const LogoutAuthEvent();

  @override
  List<Object> get props => [];
}
