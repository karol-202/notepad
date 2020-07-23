import 'package:equatable/equatable.dart';
import 'package:notepad/model/note.dart';

class NoteEditState extends Equatable {
  final Note savedNote;
  final NoteEditStateEditStatus editStatus;
  final NoteEditStateDeleteStatus deleteStatus;
  final NoteEditStateError error;

  const NoteEditState(
    this.savedNote, {
    this.editStatus = NoteEditStateEditStatus.idle,
    this.deleteStatus = NoteEditStateDeleteStatus.none,
    this.error,
  });

  NoteEditState copy({
    Note savedNote,
    NoteEditStateEditStatus editStatus,
    NoteEditStateDeleteStatus deleteStatus,
    NoteEditStateError error,
  }) =>
      NoteEditState(
        savedNote ?? this.savedNote,
        editStatus: editStatus ?? this.editStatus,
        deleteStatus: deleteStatus ?? this.deleteStatus,
        error: error ?? this.error,
      );

  @override
  List<Object> get props => [savedNote, editStatus, deleteStatus, error];

  bool get canDelete => savedNote != null;
}

enum NoteEditStateEditStatus { idle, editing, saving }

enum NoteEditStateDeleteStatus { none, deleting, deleted }

enum NoteEditStateError { network, other }
