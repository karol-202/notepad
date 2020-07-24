import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  @JsonKey(ignore: true)
  final String id;
  final String title;
  final String content;

  const Note({
    this.id = '',
    this.title = '',
    this.content = '',
  });

  factory Note.fromJson(String id, Map<String, dynamic> json) => _$NoteFromJson(json).copy(id: id);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  Note copy({
    String id,
    String title,
    String content,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
      );
}
