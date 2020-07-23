import 'package:equatable/equatable.dart';
import 'package:notepad/model/note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
}

class NotesUpdatedNotesEvent extends NotesEvent {
  final List<Note> notes;

  const NotesUpdatedNotesEvent(this.notes);

  @override
  List<Object> get props => [notes];
}

class RefreshNotesEvent extends NotesEvent {
  const RefreshNotesEvent();

  @override
  List<Object> get props => [];
}

class DeleteNoteNotesEvent extends NotesEvent {
  final String noteId;

  const DeleteNoteNotesEvent(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class DeleteNotesNotesEvent extends NotesEvent {
  final List<String> noteIds;

  const DeleteNotesNotesEvent(this.noteIds);

  @override
  List<Object> get props => [noteIds];
}

class DeleteAllNotesEvent extends NotesEvent {
  const DeleteAllNotesEvent();

  @override
  List<Object> get props => [];
}

class ClearFailureNotesEvent extends NotesEvent {
  const ClearFailureNotesEvent();

  @override
  List<Object> get props => [];
}
