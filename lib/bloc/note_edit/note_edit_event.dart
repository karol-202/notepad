import 'package:equatable/equatable.dart';
import 'package:notepad/model/note.dart';

abstract class NoteEditEvent extends Equatable {
  const NoteEditEvent();

  @override
  List<Object> get props => [];
}

class EditNoteEditEvent extends NoteEditEvent {
  const EditNoteEditEvent();
}

class SaveNoteEditEvent extends NoteEditEvent {
  final Note note;

  const SaveNoteEditEvent(this.note);

  @override
  List<Object> get props => super.props + [note];
}

class DeleteNoteEditEvent extends NoteEditEvent {
  const DeleteNoteEditEvent();
}

class ClearErrorNoteEditEvent extends NoteEditEvent {
  const ClearErrorNoteEditEvent();
}
