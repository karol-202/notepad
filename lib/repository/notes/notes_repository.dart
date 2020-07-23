import 'package:notepad/model/note.dart';

abstract class NotesRepository {
  Stream<List<Note>> getNotes();

  Future<void> refreshNotes();

  Future<Note> addNote(Note note);

  Future<void> updateNote(Note note);

  Future<void> deleteNote(String noteId);

  Future<void> deleteNotes(List<String> noteIds);

  Future<void> deleteAll();

  void dispose() {}
}
