import 'dart:async';

import 'package:flutter/services.dart';
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

Future<T> catchAuthExceptions<T>(Future<T> Function() function) async {
  try {
    return await function();
  }
  on TimeoutException {
    throw ApiConnectionException();
  }
  on PlatformException catch(e) {
    switch(e.code) {
      case 'ERROR_NETWORK_REQUEST_FAILED': throw ApiConnectionException();
      default: throw AuthApiCannotAuthException(e.message);
    }
  }
  catch(e) {
    throw AuthApiOtherException(e.toString());
  }
}
