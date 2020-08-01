import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:notepad/api/photo/photo_api.dart';
import 'package:notepad/api/photo/photo_update_state.dart';
import 'package:notepad/bloc/note_edit/note_edit_photo_state.dart';
import 'package:notepad/model/note.dart';

abstract class NoteEditEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EditNoteEditEvent extends NoteEditEvent {}

class SaveNoteEditEvent extends NoteEditEvent {
  final Note note;

  SaveNoteEditEvent(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNoteEditEvent extends NoteEditEvent {}

class AddPhotoNoteEditEvent extends NoteEditEvent {
  final String photoPath;

  AddPhotoNoteEditEvent(this.photoPath);

  @override
  List<Object> get props => [photoPath];
}

class CancelPhotoUploadNoteEditEvent extends NoteEditEvent {
  final PhotoUploadTask task;

  CancelPhotoUploadNoteEditEvent(this.task);

  @override
  List<Object> get props => [task];
}

class RetryPhotoUploadNoteEditEvent extends NoteEditEvent {
  final File file;

  RetryPhotoUploadNoteEditEvent(this.file);

  @override
  List<Object> get props => [file];
}

class PhotoUploadUpdatedNoteEditEvent extends NoteEditEvent {
  final PhotoUploadTask task;
  final PhotoUploadState state;

  PhotoUploadUpdatedNoteEditEvent(this.task, this.state);

  @override
  List<Object> get props => [task, state];
}
