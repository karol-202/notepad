import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  @JsonKey(ignore: true)
  final String id;
  final String title;
  final String content;
  @JsonKey(name: 'photoUrls')
  final Map<String, String> photoUrlsMap;

  List<String> get photoUrls => photoUrlsMap.values.toList();

  Note({
    this.id = '',
    this.title = '',
    this.content = '',
    Map<String, String> photoUrlsMap,
  }) : photoUrlsMap = photoUrlsMap ?? {};

  factory Note.fromJson(String id, Map<String, dynamic> json) => _$NoteFromJson(json).withId(id);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  Note withId(String id) => Note(id: id, title: title, content: content, photoUrlsMap: photoUrlsMap);

  Note withNewPhoto(String url) =>
      Note(id: id, title: title, content: content, photoUrlsMap: {...photoUrlsMap}..[Uuid().v4()] = url);

  Note withNewPhotos(List<String> urls) => urls.fold(this, (note, url) => note.withNewPhoto(url));
}
