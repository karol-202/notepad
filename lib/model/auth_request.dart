import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

@JsonSerializable()
class AuthRequest {
  final String email;
  final String password;
  final bool returnSecureToken;

  AuthRequest(this.email, this.password, {this.returnSecureToken = true});

  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}
