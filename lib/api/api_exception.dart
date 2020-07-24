abstract class ApiException implements Exception {}

class ApiConnectionException implements ApiException {
  @override
  String toString() => "ApiConnectionException";
}

class ApiDataException implements ApiException {
  final cause;

  const ApiDataException(this.cause);

  @override
  String toString() => "ApiDataException: $cause";
}
