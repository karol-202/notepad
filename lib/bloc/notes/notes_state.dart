import 'package:equatable/equatable.dart';
import 'package:notepad/model/note.dart';

abstract class NotesState extends Equatable {
  final List<Note> notes;

  const NotesState(this.notes);

  @override
  List<Object> get props => [notes];

  int get notesCount => notes.length;

  List<Note> getNotesByIds(List<String> ids) => notes.where((note) => ids.contains(note.id)).toList();

  NotesState withNotes(List<Note> notes);
}

class SuccessNotesState extends NotesState {
  const SuccessNotesState(List<Note> notes) : super(notes);

  @override
  NotesState withNotes(List<Note> notes) => SuccessNotesState(notes);
}

class LoadingNotesState extends NotesState {
  const LoadingNotesState(List<Note> notes) : super(notes);

  @override
  NotesState withNotes(List<Note> notes) => LoadingNotesState(notes);
}

class FailureNotesState extends NotesState {
  final NotesStateError error;

  const FailureNotesState(List<Note> notes, this.error) : super(notes);

  @override
  List<Object> get props => super.props + [error];

  @override
  NotesState withNotes(List<Note> notes) => FailureNotesState(notes, error);
}

enum NotesStateError {
  network, other
}
