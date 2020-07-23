import 'dart:async';

import 'package:notepad/dao/notes/notes_dao.dart';
import 'package:notepad/model/note.dart';

class MemoryNotesDao extends NotesDao {
  final _notes = <Note>[];
  final _controller = StreamController<List<Note>>();

  @override
  Stream<List<Note>> getNotes() => _controller.stream;

  @override
  Future<void> replaceNotes(List<Note> notes) {
    _notes.clear();
    _notes.addAll(notes);
    _broadcast();
  }

  @override
  Future<void> addNote(Note note) async {
    _notes.add(note);
    _broadcast();
  }

  @override
  Future<void> updateNote(Note note) async {
    final index = _notes.indexWhere((item) => item.id == note.id);
    _notes[index] = note;
    _broadcast();
  }

  @override
  Future<void> deleteNote(String noteId) async {
    _notes.removeWhere((note) => note.id == noteId);
    _broadcast();
  }

  @override
  Future<void> deleteAll() {
    _notes.clear();
    _broadcast();
  }

  void _broadcast() => _controller.add([..._notes]);

  @override
  void dispose() {
    _controller.close();
  }
}
