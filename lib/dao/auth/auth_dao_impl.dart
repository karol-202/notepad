import 'dart:async';
import 'dart:convert';

import 'package:notepad/dao/auth/auth_dao.dart';
import 'package:notepad/model/auth_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsAuthDao extends AuthDao {
  static const _KEY_AUTH_STATE = 'AUTH_STATE';

  final _controller = StreamController<AuthData>();
  SharedPreferences _preferences;

  @override
  Stream<AuthData> getAuthState() async* {
    await _updateAuthStateStreamFromPrefs();
    yield* _controller.stream;
  }

  @override
  Future<void> setAuthState(AuthData state) async {
    final prefs = await getSharedPreferences();
    final stateJson = state != null ? json.encode(state.toJson()) : null;
    prefs.setString(_KEY_AUTH_STATE, stateJson);
    _controller.add(state);
  }

  Future<void> _updateAuthStateStreamFromPrefs() async {
    final prefs = await getSharedPreferences();
    final stateJson = prefs.getString(_KEY_AUTH_STATE);
    final state = stateJson != null ? AuthData.fromJson(json.decode(stateJson)) : null;
    _controller.add(state);
  }

  Future<SharedPreferences> getSharedPreferences() async =>
      _preferences ??= await SharedPreferences.getInstance();

  @override
  void dispose() {
    _controller.close();
  }
}
