import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/api/api_exception.dart';
import 'package:notepad/bloc/note_edit/note_edit_event.dart';
import 'package:notepad/bloc/note_edit/note_edit_state.dart';
import 'package:notepad/model/note.dart';
import 'package:notepad/repository/notes/notes_repository.dart';

class NoteEditBlocFactory {
  final NotesRepository notesRepository;

  const NoteEditBlocFactory(this.notesRepository);

  NoteEditBloc create(Note savedNote) => NoteEditBloc(notesRepository, savedNote);
}

class NoteEditBloc extends Bloc<NoteEditEvent, NoteEditState> {
  final NotesRepository notesRepository;

  NoteEditBloc(this.notesRepository, Note savedNote) : super(NoteEditState(savedNote));

  @override
  Stream<NoteEditState> mapEventToState(NoteEditEvent event) async* {
    if (event is EditNoteEditEvent)
      yield* _mapEditToState();
    else if (event is SaveNoteEditEvent)
      yield* _mapSaveToState(event);
    else if (event is DeleteNoteEditEvent)
      yield* _mapDeleteToState();
    else if (event is ClearErrorNoteEditEvent) yield* _mapClearErrorToState();
  }

  Stream<NoteEditState> _mapEditToState() async* {
    if (state.editStatus == NoteEditStateEditStatus.idle)
      yield state.copy(editStatus: NoteEditStateEditStatus.editing);
  }

  Stream<NoteEditState> _mapSaveToState(SaveNoteEditEvent event) async* {
    if (state.editStatus == NoteEditStateEditStatus.editing) {
      yield* _mapCatching(() async* {
        yield state.copy(editStatus: NoteEditStateEditStatus.saving);
        if (state.savedNote == null) {
          final createdNote = await notesRepository.addNote(event.note);
          yield state.copy(savedNote: createdNote, editStatus: NoteEditStateEditStatus.idle);
        } else {
          final noteToUpdate = event.note.copy(id: state.savedNote.id);
          await notesRepository.updateNote(noteToUpdate);
          yield state.copy(savedNote: event.note, editStatus: NoteEditStateEditStatus.idle);
        }
      });
    }
  }

  Stream<NoteEditState> _mapDeleteToState() async* {
    if(state.savedNote != null) {
      yield* _mapCatching(() async* {
        yield state.copy(deleteStatus: NoteEditStateDeleteStatus.deleting);
        await notesRepository.deleteNote(state.savedNote.id);
        yield state.copy(deleteStatus: NoteEditStateDeleteStatus.deleted);
      });
    }
  }

  Stream<NoteEditState> _mapCatching(Stream<NoteEditState> Function() operation) async* {
    final previousState = state;
    try {
      await for (var value in operation()) yield value;
    } on ApiConnectionException {
      yield previousState.copy(error: NoteEditStateError.network);
    } on Exception {
      yield previousState.copy(error: NoteEditStateError.other);
    }
  }

  Stream<NoteEditState> _mapClearErrorToState() async* {
    yield state.copy(error: null);
  }
}
