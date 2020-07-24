import 'dart:convert';

import 'package:notepad/api/auth/auth_api.dart';
import 'package:notepad/api/base_api.dart';
import 'package:notepad/model/auth_request.dart';
import 'package:notepad/model/login_result.dart';
import 'package:notepad/model/register_result.dart';
import 'package:notepad/provider/config/config_provider.dart';

class FirebaseAuthApi extends AuthApi {
  static const _OPERATION_REGISTER = 'signUp';
  static const _OPERATION_LOGIN = 'signInWithPassword';

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
    return resultFactory(resultJson);
  }

  String _prepareApiUrl(String operation, String apiKey) =>
      'https://identitytoolkit.googleapis.com/v1/accounts:$operation?key=$apiKey';
}
