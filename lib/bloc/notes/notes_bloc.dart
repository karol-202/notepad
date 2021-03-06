import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/api/api_exception.dart';
import 'package:notepad/bloc/notes/notes_event.dart';
import 'package:notepad/bloc/notes/notes_state.dart';
import 'package:notepad/repository/notes/notes_repository.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;

  StreamSubscription _notesSubscription;

  NotesBloc(this.notesRepository) : super(SuccessNotesState([])) {
    _listenForNotes();
  }

  void _listenForNotes() => _notesSubscription = notesRepository.getNotes().listen((notes) {
        add(NotesUpdatedNotesEvent(notes));
      });

  @override
  Stream<NotesState> mapEventToState(NotesEvent event) => _mapCatching(() async* {
        if (event is NotesUpdatedNotesEvent)
          yield* _mapUpdatedToState(event);
        else if (event is RefreshNotesEvent)
          yield* _mapRefreshToState();
        else if (event is DeleteNoteNotesEvent)
          yield* _mapDeleteNoteToState(event);
        else if (event is DeleteNotesNotesEvent)
          yield* _mapDeleteNotesToState(event);
        else if (event is DeleteAllNotesEvent) yield* _mapDeleteAllToState();
      });

  Stream<NotesState> _mapUpdatedToState(NotesUpdatedNotesEvent event) async* {
    yield state.withNotes(event.notes);
  }

  Stream<NotesState> _mapRefreshToState() async* {
    yield LoadingNotesState(state.notes);
    await notesRepository.refreshNotes();
    yield SuccessNotesState(state.notes);
  }

  Stream<NotesState> _mapDeleteNoteToState(DeleteNoteNotesEvent event) async* {
    await notesRepository.deleteNote(event.noteId);
  }

  Stream<NotesState> _mapDeleteNotesToState(DeleteNotesNotesEvent event) async* {
    await notesRepository.deleteNotes(event.noteIds);
  }

  Stream<NotesState> _mapDeleteAllToState() async* {
    await notesRepository.deleteAll();
  }

  Stream<NotesState> _mapCatching(Stream<NotesState> Function() operation) async* {
    final previousState = state;
    try {
      // Using await for instead of yield*, because yield* leaves exceptions unhandled due to a bug
      await for (var value in operation()) yield value;
    } on ApiConnectionException {
      yield FailureNotesState(state.notes, NotesStateError.network);
      yield previousState;
    } catch(e, s) {
      print('$e\n$s');
      yield FailureNotesState(state.notes, NotesStateError.other);
      yield previousState;
    }
  }

  @override
  Future<void> close() async {
    await _notesSubscription.cancel();
    await super.close();
  }
}
