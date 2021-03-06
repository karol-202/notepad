import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notepad/api/photo/firebase_photo_api.dart';
import 'package:notepad/api/photo/photo_api.dart';
import 'package:notepad/bloc/auth/auth_bloc.dart';
import 'package:notepad/bloc/camera/camera_bloc.dart';
import 'package:notepad/repository/auth/auth_repository.dart';
import 'package:notepad/repository/auth/firebase_auth_repository.dart';
import 'package:notepad/repository/notes/notes_repository.dart';
import 'package:notepad/repository/notes/notes_repository_impl.dart';

import 'api/notes/firebase_notes_api.dart';
import 'api/notes/notes_api.dart';
import 'bloc/note_edit/note_edit_bloc.dart';
import 'bloc/notes/notes_bloc.dart';
import 'bloc/notes_selection/notes_selection_bloc.dart';
import 'dao/notes/memory_notes_dao.dart';
import 'dao/notes/notes_dao.dart';
import 'widget/application.dart';

GetIt _getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  runApp(Application(
    authBloc: _getIt.get<AuthBloc>(),
    notesBloc: _getIt.get<NotesBloc>(),
    notesSelectionBloc: _getIt.get<NotesSelectionBloc>(),
    noteEditBlocFactory: _getIt.get<NoteEditBlocFactory>(),
    cameraBloc: _getIt.get<CameraBloc>(),
  ));
}

void setupGetIt() {
  _getIt.registerSingleton<AuthRepository>(FirebaseAuthRepository());
  _getIt.registerSingleton<NotesApi>(FirebaseNotesApi(_getIt.get<AuthRepository>()));
  _getIt.registerSingleton<NotesDao>(MemoryNotesDao());
  _getIt.registerSingleton<NotesRepository>(
      NotesRepositoryImpl(_getIt.get<NotesApi>(), _getIt.get<NotesDao>()));
  _getIt.registerSingleton<PhotoApi>(FirebasePhotoApi(_getIt.get<AuthRepository>()));
  _getIt.registerSingleton<AuthBloc>(AuthBloc(_getIt.get<AuthRepository>()));
  _getIt.registerSingleton<NotesBloc>(NotesBloc(_getIt.get<NotesRepository>()));
  _getIt.registerSingleton<NotesSelectionBloc>(NotesSelectionBloc(_getIt.get<NotesBloc>()));
  _getIt.registerSingleton<NoteEditBlocFactory>(NoteEditBlocFactory(_getIt.get<NotesRepository>(), _getIt.get<PhotoApi>()));
  _getIt.registerSingleton<CameraBloc>(CameraBloc());
}
