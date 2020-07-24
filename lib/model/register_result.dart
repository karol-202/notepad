import 'package:json_annotation/json_annotation.dart';

part 'register_result.g.dart';

@JsonSerializable()
class RegisterResult {
  final String idToken;
  final String email;
  final String refreshToken;
  final String expiresIn;
  final String localId;

  const RegisterResult(this.idToken, this.email, this.refreshToken, this.expiresIn, this.localId);

  factory RegisterResult.fromJson(Map<String, dynamic> json) => _$RegisterResultFromJson(json);
}
