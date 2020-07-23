import 'package:equatable/equatable.dart';
import 'package:notepad/model/note.dart';

abstract class NotesSelectionEvent extends Equatable {
  const NotesSelectionEvent();
}

class NotesUpdatedNotesSelectionEvent extends NotesSelectionEvent {
  final List<Note> newNotes;

  const NotesUpdatedNotesSelectionEvent(this.newNotes);

  @override
  List<Object> get props => [newNotes];
}

class ToggleNotesSelectionEvent extends NotesSelectionEvent {
  final String noteId;

  const ToggleNotesSelectionEvent(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class ClearNotesSelectionEvent extends NotesSelectionEvent {
  const ClearNotesSelectionEvent();

  @override
  List<Object> get props => [];
}
