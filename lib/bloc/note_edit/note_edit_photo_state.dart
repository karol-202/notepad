import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notepad/api/photo/photo_api.dart';

abstract class NoteEditPhotoState extends Equatable {
  ImageProvider get imageProvider;
}

class CompletedNoteEditPhotoState extends NoteEditPhotoState {
  final String url;
  final File file;

  CompletedNoteEditPhotoState(this.url, [this.file]);

  @override
  List<Object> get props => [url];

  @override
  ImageProvider get imageProvider => file != null ? FileImage(file) : NetworkImage(url);
}

class InProgressNoteEditPhotoState extends NoteEditPhotoState {
  final File file;
  final PhotoUploadTask task;
  final StreamSubscription subscription;
  final double progress;

  InProgressNoteEditPhotoState(this.file, this.task, this.subscription, this.progress);

  @override
  List<Object> get props => [file, task, subscription, progress];

  @override
  ImageProvider get imageProvider => FileImage(file);
}

class FailedNoteEditPhotoState extends NoteEditPhotoState {
  final File file;

  FailedNoteEditPhotoState(this.file);

  @override
  List<Object> get props => [file];

  @override
  ImageProvider get imageProvider => FileImage(file);
}
