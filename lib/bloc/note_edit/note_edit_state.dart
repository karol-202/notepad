import 'package:equatable/equatable.dart';
import 'package:notepad/bloc/note_edit/note_edit_photo_state.dart';
import 'package:notepad/model/note.dart';

abstract class NoteEditState extends Equatable {
  final List<NoteEditPhotoState> photos;
  final NoteEditStateEditStatus editStatus;
  final NoteEditStateDeleteStatus deleteStatus;
  final NoteEditStateError error;

  NoteEditState(this.photos, this.editStatus, this.deleteStatus, this.error);

  bool get canDelete;

  @override
  List<Object> get props => [photos, editStatus, deleteStatus, error];

  NoteEditState withPhotos(List<NoteEditPhotoState> photos);

  NoteEditState withEditStatus(NoteEditStateEditStatus status);

  NoteEditState withDeleteStatus(NoteEditStateDeleteStatus status);

  NoteEditState withError(NoteEditStateError error);
}

class NewNoteEditState extends NoteEditState {
  NewNoteEditState([
    List<NoteEditPhotoState> photos,
    NoteEditStateEditStatus editStatus = NoteEditStateEditStatus.idle,
    NoteEditStateDeleteStatus deleteStatus = NoteEditStateDeleteStatus.none,
    NoteEditStateError error,
  ]) : super(photos, editStatus, deleteStatus, error);

  @override
  bool get canDelete => false;

  @override
  NoteEditState withPhotos(List<NoteEditPhotoState> photos) =>
      NewNoteEditState(photos, editStatus, deleteStatus, error);

  @override
  NoteEditState withEditStatus(NoteEditStateEditStatus status) =>
      NewNoteEditState(photos, status, deleteStatus, error);

  @override
  NoteEditState withDeleteStatus(NoteEditStateDeleteStatus status) =>
      NewNoteEditState(photos, editStatus, status, error);

  @override
  NoteEditState withError(NoteEditStateError error) =>
      NewNoteEditState(photos, editStatus, deleteStatus, error);
}

class ExistingNoteEditState extends NoteEditState {
  final Note savedNote;

  ExistingNoteEditState(
    this.savedNote, [
    List<NoteEditPhotoState> photos,
    NoteEditStateEditStatus editStatus = NoteEditStateEditStatus.idle,
    NoteEditStateDeleteStatus deleteStatus = NoteEditStateDeleteStatus.none,
    NoteEditStateError error,
  ]) : super(photos, editStatus, deleteStatus, error);

  @override
  bool get canDelete => true;

  @override
  List<Object> get props => super.props + [savedNote];

  @override
  NoteEditState withPhotos(List<NoteEditPhotoState> photos) =>
      ExistingNoteEditState(savedNote, photos, editStatus, deleteStatus, error);

  @override
  ExistingNoteEditState withEditStatus(NoteEditStateEditStatus status) =>
      ExistingNoteEditState(savedNote, photos, status, deleteStatus, error);

  @override
  ExistingNoteEditState withDeleteStatus(NoteEditStateDeleteStatus status) =>
      ExistingNoteEditState(savedNote, photos, editStatus, status, error);

  @override
  ExistingNoteEditState withError(NoteEditStateError error) =>
      ExistingNoteEditState(savedNote, photos, editStatus, deleteStatus, error);
}

enum NoteEditStateEditStatus { idle, editing, saving }

enum NoteEditStateDeleteStatus { none, deleting, deleted }

enum NoteEditStateError { network, other }
