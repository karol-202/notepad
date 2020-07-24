import 'package:notepad/model/login_result.dart';
import 'package:notepad/model/register_result.dart';

abstract class AuthApi {
  Future<RegisterResult> register(String email, String password);

  Future<LoginResult> login(String email, String password);

  void dispose() {}
}
