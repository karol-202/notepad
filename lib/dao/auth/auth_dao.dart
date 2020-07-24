import 'package:notepad/model/auth_state.dart';

abstract class AuthDao {
  Stream<AuthState> getAuthState();

  Future<void> setAuthState(AuthState state);

  void dispose() {}
}
