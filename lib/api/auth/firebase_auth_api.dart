import 'dart:convert';

import 'package:notepad/api/auth/auth_api.dart';
import 'package:notepad/api/auth/auth_exception.dart';
import 'package:notepad/api/base_api.dart';
import 'package:notepad/model/auth_request.dart';
import 'package:notepad/model/error_response.dart';
import 'package:notepad/model/login_result.dart';
import 'package:notepad/model/register_result.dart';
import 'package:notepad/provider/config/config_provider.dart';

class FirebaseAuthApi extends AuthApi {
  static const _OPERATION_REGISTER = 'signUp';
  static const _OPERATION_LOGIN = 'signInWithPassword';

  static const _ERROR_EMAIL_EXISTS = 'EMAIL_EXISTS';
  static const _ERROR_EMAIL_NOT_FOUND = 'EMAIL_NOT_FOUND';
  static const _ERROR_INVALID_PASSWORD = 'INVALID_PASSWORD';

  final BaseApi api;
  final ConfigProvider configProvider;

  FirebaseAuthApi(this.api, this.configProvider);

  @override
  Future<RegisterResult> register(String email, String password) =>
      _sendAuthRequest(email, password, _OPERATION_REGISTER, (json) => RegisterResult.fromJson(json));

  @override
  Future<LoginResult> login(String email, String password) =>
      _sendAuthRequest(email, password, _OPERATION_LOGIN, (json) => LoginResult.fromJson(json));

  Future<R> _sendAuthRequest<R>(
      String email, String password, String operation, R Function(Map<String, dynamic>) resultFactory) async {
    final url = _prepareApiUrl(operation, await configProvider.getApiKey());
    final request = json.encode(AuthRequest(email, password).toJson());
    final resultJson = await api.post(url, request).fromJson();
    _throwAuthExceptionIfError(resultJson);
    return tryToParse(() => resultFactory(resultJson));
  }

  void _throwAuthExceptionIfError(Map<String, dynamic> json) {
    final errorJson = json['error'];
    if(errorJson == null) return;

    ErrorResponse error = tryToParse(() => ErrorResponse.fromJson(errorJson));
    switch(error.message) {
      case _ERROR_EMAIL_EXISTS: throw AuthApiEmailExistsException();
      case _ERROR_EMAIL_NOT_FOUND:
      case _ERROR_INVALID_PASSWORD: throw AuthApiCannotLoginException();
      default: throw AuthApiOtherException();
    }
  }

  String _prepareApiUrl(String operation, String apiKey) =>
      'https://identitytoolkit.googleapis.com/v1/accounts:$operation?key=$apiKey';
}
