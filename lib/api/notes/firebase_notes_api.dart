import 'dart:convert';

import 'package:notepad/api/api.dart' as api;
import 'package:notepad/api/api_exception.dart';
import 'package:notepad/api/notes/notes_api.dart';
import 'package:notepad/model/note.dart';

class FirebaseNotesApi extends NotesApi {
  static const API_URL = 'https://flutter-notepad-bbef9.firebaseio.com';

  @override
  Future<List<Note>> getNotes() async {
    final notesData = await api.get('$API_URL/notes.json');
    try {
      final notesJson = notesData as Map<String, dynamic> ?? {};
      return notesJson.entries.map((entry) => Note.fromJson(entry.key, entry.value)).toList();
    }
    catch(e) {
      throw ApiDataException(e);
    }
  }

  @override
  Future<Note> addNote(Note note) async {
    final responseData = await api.post('$API_URL/notes.json', json.encode(note.toJson()));
    final noteId = responseData['name'] as String;
    return note.copy(id: noteId);
  }

  @override
  Future<void> updateNote(Note note) async {
    await api.put('$API_URL/notes/${note.id}.json', json.encode(note.toJson()));
  }

  @override
  Future<void> deleteNote(String id) async {
    await api.delete('$API_URL/notes/$id.json');
  }

  @override
  Future<void> deleteAll() async {
    await api.delete('$API_URL/notes.json');
  }
}
