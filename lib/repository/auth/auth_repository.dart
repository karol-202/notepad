import 'package:notepad/model/auth_data.dart';

abstract class AuthRepository {
  Stream<AuthData> getAuthState();

  Future<void> register(String email, String password);

  Future<void> login(String email, String password);

  Future<void> logout();

  void dispose() {}
}
