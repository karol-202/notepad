import 'dart:async';
import 'dart:convert';

import 'package:notepad/dao/auth/auth_dao.dart';
import 'package:notepad/model/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsAuthDaoImpl extends AuthDao {
  static const _KEY_AUTH_STATE = 'AUTH_STATE';

  final _controller = StreamController<AuthState>();
  SharedPreferences _preferences;

  @override
  Stream<AuthState> getAuthState() async* {
    await _updateAuthStateStreamFromPrefs();
    yield* _controller.stream;
  }

  @override
  Future<void> setAuthState(AuthState state) async {
    final prefs = await getSharedPreferences();
    final stateJson = json.encode(state.toJson());
    prefs.setString(_KEY_AUTH_STATE, stateJson);
    _controller.add(state);
  }

  Future<void> _updateAuthStateStreamFromPrefs() async {
    final prefs = await getSharedPreferences();
    final stateJson = prefs.getString(_KEY_AUTH_STATE);
    final state = AuthState.fromJson(json.decode(stateJson));
    _controller.add(state);
  }

  Future<SharedPreferences> getSharedPreferences() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _controller.close();
  }
}
