import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/notes/notes_bloc.dart';
import 'package:notepad/bloc/notes_selection/notes_selection_event.dart';
import 'package:notepad/bloc/notes_selection/notes_selection_state.dart';

class NotesSelectionBloc extends Bloc<NotesSelectionEvent, NotesSelectionState> {
  final NotesBloc notesBloc;

  StreamSubscription _notesSubscription;

  NotesSelectionBloc(this.notesBloc) : super(NotesSelectionState([])) {
    _listenForNotes();
  }

  void _listenForNotes() => _notesSubscription = notesBloc.listen((state) {
        add(NotesUpdatedNotesSelectionEvent(state.notes));
      });

  @override
  Stream<NotesSelectionState> mapEventToState(NotesSelectionEvent event) async* {
    if (event is NotesUpdatedNotesSelectionEvent)
      yield* _mapNotesUpdatedToState(event);
    else if (event is ToggleNotesSelectionEvent) yield* _mapToggleToState(event);
    else if(event is ClearNotesSelectionEvent) yield* _mapClearToState();
  }

  Stream<NotesSelectionState> _mapNotesUpdatedToState(NotesUpdatedNotesSelectionEvent event) async* {
    bool doesStillExist(String id) => event.newNotes.any((newNote) => newNote.id == id);
    yield NotesSelectionState(state.selectedIds.where((selectedId) => doesStillExist(selectedId)).toList());
  }

  Stream<NotesSelectionState> _mapToggleToState(ToggleNotesSelectionEvent event) async* {
    bool isSelected = state.selectedIds.any((selectedId) => selectedId == event.noteId);
    List<String> newSelectedIds = isSelected
        ? state.selectedIds.where((selectedId) => selectedId != event.noteId).toList()
        : state.selectedIds.followedBy([event.noteId]).toList();
    yield NotesSelectionState(newSelectedIds);
  }

  Stream<NotesSelectionState> _mapClearToState() async* {
    yield NotesSelectionState([]);
  }

  @override
  Future<void> close() async {
    await _notesSubscription.cancel();
    await super.close();
  }
}
