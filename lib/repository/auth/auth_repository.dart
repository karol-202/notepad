import 'package:notepad/model/user.dart';

abstract class AuthRepository {
  Stream<User> getAuthState();

  Future<void> register(String email, String password);

  Future<void> login(String email, String password);

  Future<void> loginWithGoogle();

  Future<void> logout();

  void dispose() {}
}
