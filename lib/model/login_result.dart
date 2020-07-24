import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
  final String idToken;
  final String email;
  final String refreshToken;
  final String expiresIn;
  final String localId;
  final bool registered;

  const LoginResult(
      this.idToken, this.email, this.refreshToken, this.expiresIn, this.localId, this.registered);

  factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);
}
