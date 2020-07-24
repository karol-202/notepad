import 'package:notepad/api/api_exception.dart';

abstract class AuthApiException implements ApiException {}

class AuthApiEmailExistsException implements AuthApiException {
  @override
  String toString() => 'AuthApiEmailExistsException';
}

class AuthApiCannotLoginException implements AuthApiException {
  @override
  String toString() => 'AuthApiCannotLoginException';
}

class AuthApiOtherException implements AuthApiException {
  @override
  String toString() => 'AuthApiOtherException';
}
