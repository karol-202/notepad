import 'package:notepad/api/auth/auth_api.dart';
import 'package:notepad/dao/auth/auth_dao.dart';
import 'package:notepad/model/auth_data.dart';
import 'package:notepad/repository/auth/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApi authApi;
  final AuthDao authDao;

  AuthRepositoryImpl(this.authApi, this.authDao);

  @override
  Stream<AuthData> getAuthState() => authDao.getAuthState();

  @override
  Future<void> register(String email, String password) async {
    final registerResult = await authApi.register(email, password);
    final authState = AuthData(registerResult.idToken);
    await authDao.setAuthState(authState);
  }

  @override
  Future<void> login(String email, String password) async {
    final loginResult = await authApi.login(email, password);
    final authState = AuthData(loginResult.idToken);
    await authDao.setAuthState(authState);
  }

  @override
  Future<void> logout() async => await authDao.setAuthState(null);
}
