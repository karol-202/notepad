import 'package:notepad/model/auth_state.dart';

abstract class AuthRepository {
  Stream<AuthState> getAuthState();

  Future<void> register(String email, String password);

  Future<void> login(String email, String password);

  void dispose() {}
}
