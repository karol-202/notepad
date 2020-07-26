import 'package:notepad/model/auth_data.dart';

abstract class AuthDao {
  Stream<AuthData> getAuthState();

  Future<void> setAuthState(AuthData state);

  void dispose() {}
}
