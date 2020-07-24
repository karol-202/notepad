import 'dart:convert';

import 'package:notepad/api/base_api.dart';
import 'package:notepad/api/notes/notes_api.dart';
import 'package:notepad/model/note.dart';

class FirebaseNotesApi extends NotesApi {
  static const _API_URL = 'https://flutter-notepad-bbef9.firebaseio.com';

  final BaseApi api;

  FirebaseNotesApi(this.api);

  @override
  Future<List<Note>> getNotes() async {
    final notesJson = await api.get('$_API_URL/notes.json').fromJson();
    return tryToParse(() {
      return notesJson.entries.map((entry) => Note.fromJson(entry.key, entry.value)).toList();
    });
  }

  @override
  Future<Note> addNote(Note note) async {
    final responseData = await api.post('$_API_URL/notes.json', json.encode(note.toJson())).fromJson();
    final noteId = responseData['name'] as String;
    return note.copy(id: noteId);
  }

  @override
  Future<void> updateNote(Note note) async {
    await api.put('$_API_URL/notes/${note.id}.json', json.encode(note.toJson()));
  }

  @override
  Future<void> deleteNote(String id) async {
    await api.delete('$_API_URL/notes/$id.json');
  }

  @override
  Future<void> deleteAll() async {
    await api.delete('$_API_URL/notes.json');
  }
}
