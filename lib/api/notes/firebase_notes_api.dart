import 'package:firebase_database/firebase_database.dart';
import 'package:notepad/api/api_exception.dart';
import 'package:notepad/api/notes/notes_api.dart';
import 'package:notepad/model/note.dart';

class FirebaseNotesApi extends NotesApi {
  static const _TIMEOUT = Duration(seconds: 3);

  final notesRef = FirebaseDatabase.instance.reference().child('notes');

  FirebaseNotesApi();

  @override
  Future<List<Note>> getNotes() => catchApiExceptions(() async {
        final notesSnapshot = await notesRef.once().timeout(_TIMEOUT);
        final notesJson = (notesSnapshot.value as Map)
            .cast<String, Map>()
            .map((key, value) => MapEntry(key, value.cast<String, dynamic>()));
        return notesJson.entries.map((entry) => Note.fromJson(entry.key, entry.value)).toList();
      });

  @override
  Future<Note> addNote(Note note) => catchApiExceptions(() async {
        final noteRef = notesRef.push();
        await noteRef.set(note.toJson()).timeout(_TIMEOUT);
        return note.copy(id: noteRef.key);
      });

  @override
  Future<void> updateNote(Note note) => catchApiExceptions(() async {
        await notesRef.child(note.id).set(note.toJson()).timeout(_TIMEOUT);
      });

  @override
  Future<void> deleteNote(String id) => catchApiExceptions(() async {
        await notesRef.child(id).remove().timeout(_TIMEOUT);
      });

  @override
  Future<void> deleteAll() => catchApiExceptions(() async {
        await notesRef.remove().timeout(_TIMEOUT);
      });
}
