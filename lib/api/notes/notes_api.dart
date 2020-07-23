import 'package:notepad/model/note.dart';

abstract class NotesApi {
  Future<List<Note>> getNotes();

  Future<Note> addNote(Note note);

  Future<void> updateNote(Note note);

  Future<void> deleteNote(String id);

  Future<void> deleteAll();

  void dispose() {}
}
