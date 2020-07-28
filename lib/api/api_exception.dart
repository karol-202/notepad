import 'dart:async';

abstract class ApiException implements Exception {}

class ApiConnectionException implements ApiException {
  @override
  String toString() => "ApiConnectionException";
}

class ApiOtherException implements ApiException {
  final cause;

  const ApiOtherException(this.cause);

  @override
  String toString() => "ApiOtherException: $cause";
}

Future<T> catchApiExceptions<T>(Future<T> Function() function) async {
  try {
    return await function();
  }
  on TimeoutException {
    throw ApiConnectionException();
  }
  catch(e) {
    throw ApiOtherException(e);
  }
}
