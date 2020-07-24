import 'package:json_annotation/json_annotation.dart';

part 'auth_state.g.dart';

@JsonSerializable()
class AuthState {
  final String token;

  AuthState(this.token);

  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}
