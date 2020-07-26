import 'package:notepad/api/api_exception.dart';

abstract class AuthApiException implements ApiException {}

class AuthApiEmailExistsException implements AuthApiException {
  @override
  String toString() => 'AuthApiEmailExistsException';
}

class AuthApiCannotAuthException implements AuthApiException {
  final String message;

  const AuthApiCannotAuthException(this.message);

  @override
  String toString() => 'AuthApiCannotAuthException: ${this.message}';
}

class AuthApiOtherException implements AuthApiException {
  final String message;

  const AuthApiOtherException(this.message);

  @override
  String toString() => 'AuthApiOtherException: ${this.message}';
}
