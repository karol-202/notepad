import 'package:notepad/api/notes/notes_api.dart';
import 'package:notepad/dao/notes/notes_dao.dart';
import 'package:notepad/model/note.dart';

import 'notes_repository.dart';

class NotesRepositoryImpl extends NotesRepository {
  final NotesApi notesApi;
  final NotesDao notesDao;

  NotesRepositoryImpl(this.notesApi, this.notesDao);

  @override
  Stream<List<Note>> getNotes() => notesDao.getNotes();

  @override
  Future<void> refreshNotes() async {
    final apiNotes = await notesApi.getNotes();
    await notesDao.replaceNotes(apiNotes);
  }

  @override
  Future<Note> addNote(Note note) async {
    final apiNote = await notesApi.addNote(note);
    await notesDao.addNote(apiNote);
    return apiNote;
  }

  @override
  Future<void> updateNote(Note note) async {
    await notesApi.updateNote(note);
    await notesDao.updateNote(note);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await notesApi.deleteNote(noteId);
    await notesDao.deleteNote(noteId);
  }

  @override
  Future<void> deleteNotes(List<String> noteIds) async {
    noteIds.forEach((noteId) async => await deleteNote(noteId));
  }

  @override
  Future<void> deleteAll() async {
    await notesApi.deleteAll();
    await notesDao.deleteAll();
  }
}
