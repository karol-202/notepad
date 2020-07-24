import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config {
  final String apiKey;

  Config(this.apiKey);

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
