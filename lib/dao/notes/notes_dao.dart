import 'package:notepad/model/note.dart';

abstract class NotesDao {
  Stream<List<Note>> getNotes();

  Future<void> replaceNotes(List<Note> notes);

  Future<void> addNote(Note note);

  Future<void> updateNote(Note note);

  Future<void> deleteNote(String noteId);

  Future<void> deleteAll();

  void dispose() {}
}
