import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notepad/api/auth/auth_api.dart';
import 'package:notepad/api/auth/firebase_auth_api.dart';
import 'package:notepad/api/base_api.dart';
import 'package:notepad/provider/config/assets_config_provider.dart';
import 'package:notepad/provider/config/config_provider.dart';
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
  setupGetIt();
  runApp(Application(
    notesBloc: _getIt.get<NotesBloc>(),
    notesSelectionBloc: _getIt.get<NotesSelectionBloc>(),
    noteEditBlocFactory: _getIt.get<NoteEditBlocFactory>(),
  ));
}

void setupGetIt() {
  _getIt.registerSingleton<ConfigProvider>(AssetsConfigProvider());
  _getIt.registerSingleton<BaseApi>(BaseApi());
  _getIt.registerSingleton<AuthApi>(FirebaseAuthApi(_getIt.get<BaseApi>(), _getIt.get<ConfigProvider>()));
  _getIt.registerSingleton<NotesApi>(FirebaseNotesApi(_getIt.get<BaseApi>()));
  _getIt.registerSingleton<NotesDao>(MemoryNotesDao());
  _getIt.registerSingleton<NotesRepository>(
      NotesRepositoryImpl(_getIt.get<NotesApi>(), _getIt.get<NotesDao>()));
  _getIt.registerSingleton<NotesBloc>(NotesBloc(_getIt.get<NotesRepository>()));
  _getIt.registerSingleton<NotesSelectionBloc>(NotesSelectionBloc(_getIt.get<NotesBloc>()));
  _getIt.registerSingleton<NoteEditBlocFactory>(NoteEditBlocFactory(_getIt.get<NotesRepository>()));
}
