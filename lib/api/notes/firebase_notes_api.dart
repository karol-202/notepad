import 'package:firebase_database/firebase_database.dart';
import 'package:notepad/api/api_exception.dart';
import 'package:notepad/api/notes/notes_api.dart';
import 'package:notepad/model/note.dart';
import 'package:notepad/repository/auth/auth_repository.dart';

class FirebaseNotesApi extends NotesApi {
  static const _TIMEOUT = Duration(seconds: 3);

  final AuthRepository authRepository;

  final dataRef = FirebaseDatabase.instance.reference();

  FirebaseNotesApi(this.authRepository);

  @override
  Future<List<Note>> getNotes() => catchApiExceptions(() async {
        final notesRef = await _getNotesRef();
        final notesSnapshot = await notesRef.once().timeout(_TIMEOUT);
        final notesJson = (notesSnapshot.value as Map ?? {})
            .cast<String, Map>()
            .map((key, value) => MapEntry(key, value.cast<String, dynamic>()));
        return notesJson.entries.map((entry) => Note.fromJson(entry.key, entry.value)).toList();
      });

  @override
  Future<Note> addNote(Note note) => catchApiExceptions(() async {
        final notesRef = await _getNotesRef();
        final noteRef = notesRef.push();
        await noteRef.set(note.toJson()).timeout(_TIMEOUT);
        return note.copy(id: noteRef.key);
      });

  @override
  Future<void> updateNote(Note note) => catchApiExceptions(() async {
        final notesRef = await _getNotesRef();
        await notesRef.child(note.id).set(note.toJson()).timeout(_TIMEOUT);
      });

  @override
  Future<void> deleteNote(String id) => catchApiExceptions(() async {
        final notesRef = await _getNotesRef();
        await notesRef.child(id).remove().timeout(_TIMEOUT);
      });

  @override
  Future<void> deleteAll() => catchApiExceptions(() async {
        final notesRef = await _getNotesRef();
        await notesRef.remove().timeout(_TIMEOUT);
      });

  Future<DatabaseReference> _getNotesRef() async =>
      dataRef.child('users').child(await _getUserId()).child('notes');

  Future<String> _getUserId() async {
    final user = await authRepository.getAuthState().first;
    return user.id;
  }
}
