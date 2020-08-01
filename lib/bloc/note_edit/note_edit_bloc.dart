import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/api/api_exception.dart';
import 'package:notepad/api/photo/photo_api.dart';
import 'package:notepad/api/photo/photo_update_state.dart';
import 'package:notepad/bloc/note_edit/note_edit_event.dart';
import 'package:notepad/bloc/note_edit/note_edit_photo_state.dart';
import 'package:notepad/bloc/note_edit/note_edit_state.dart';
import 'package:notepad/model/note.dart';
import 'package:notepad/repository/notes/notes_repository.dart';

class NoteEditBlocFactory {
  final NotesRepository notesRepository;
  final PhotoApi photoApi;

  const NoteEditBlocFactory(this.notesRepository, this.photoApi);

  NoteEditBloc create(Note savedNote) => savedNote != null
      ? NoteEditBloc.existingNote(notesRepository, photoApi, savedNote)
      : NoteEditBloc.newNote(notesRepository, photoApi);
}

class NoteEditBloc extends Bloc<NoteEditEvent, NoteEditState> {
  final NotesRepository notesRepository;
  final PhotoApi photoApi;

  NoteEditBloc.newNote(this.notesRepository, this.photoApi) : super(NewNoteEditState());

  NoteEditBloc.existingNote(this.notesRepository, this.photoApi, Note note)
      : super(ExistingNoteEditState(
          note,
          note.photoUrls.map((url) => CompletedNoteEditPhotoState(url)).toList(),
        ));

  @override
  Stream<NoteEditState> mapEventToState(NoteEditEvent event) => _mapCatching(() async* {
        if (event is EditNoteEditEvent)
          yield* _mapEditToState();
        else if (event is SaveNoteEditEvent)
          yield* _mapSaveToState(event);
        else if (event is DeleteNoteEditEvent)
          yield* _mapDeleteToState();
        else if (event is AddPhotoNoteEditEvent)
          yield* _mapAddPhotoToState(event);
        else if (event is CancelPhotoUploadNoteEditEvent)
          yield* _mapCancelPhotoUploadToState(event);
        else if (event is RetryPhotoUploadNoteEditEvent)
          yield* _mapRetryPhotoUploadToState(event);
        else if (event is PhotoUploadUpdatedNoteEditEvent) yield* _mapPhotoUploadUpdatedToState(event);
      });

  Stream<NoteEditState> _mapEditToState() async* {
    if (state.editStatus == NoteEditStateEditStatus.idle)
      yield state.withEditStatus(NoteEditStateEditStatus.editing);
  }

  Stream<NoteEditState> _mapSaveToState(SaveNoteEditEvent event) async* {
    if (state.editStatus == NoteEditStateEditStatus.editing) {
      yield state.withEditStatus(NoteEditStateEditStatus.saving);
      if (state is NewNoteEditState) {
        final completedPhotosUrls = state.photos
            .where((photo) => photo is CompletedNoteEditPhotoState)
            .map((photo) => (photo as CompletedNoteEditPhotoState).url);
        final noteWithPhotos = event.note.withNewPhotos(completedPhotosUrls);
        final createdNote = await notesRepository.addNote(noteWithPhotos);
        yield ExistingNoteEditState(createdNote);
      } else if (state is ExistingNoteEditState) {
        final state = this.state as ExistingNoteEditState;
        final newNote = event.note.withId(state.savedNote.id);
        await notesRepository.updateNote(newNote);
        yield ExistingNoteEditState(newNote);
      }
    }
  }

  Stream<NoteEditState> _mapDeleteToState() async* {
    if (state is ExistingNoteEditState) {
      final state = this.state as ExistingNoteEditState;
      yield state.withDeleteStatus(NoteEditStateDeleteStatus.deleting);
      await notesRepository.deleteNote(state.savedNote.id);
      yield state.withDeleteStatus(NoteEditStateDeleteStatus.deleted);
    }
  }

  Stream<NoteEditState> _mapAddPhotoToState(AddPhotoNoteEditEvent event) =>
      _mapStartUploadTaskToState(null, File(event.photoPath));

  Stream<NoteEditState> _mapPhotoUploadUpdatedToState(PhotoUploadUpdatedNoteEditEvent event) async* {
    final photoState = state.photos.firstWhere(
      (photo) => photo is InProgressNoteEditPhotoState && photo.task == event.task,
      orElse: null,
    ) as InProgressNoteEditPhotoState;
    if (photoState == null) return;
    final uploadState = event.state;
    if (uploadState is CompletedPhotoUploadState)
      yield* _mapCompletedPhotoUploadUpdatedToState(photoState, uploadState);
    else if (uploadState is InProgressPhotoUploadState)
      yield* _mapInProgressPhotoUploadUpdatedToState(photoState, uploadState);
    else if (uploadState is FailedPhotoUploadState)
      yield* _mapFailedPhotoUploadUpdatedToState(photoState, uploadState);
  }

  Stream<NoteEditState> _mapCompletedPhotoUploadUpdatedToState(
    InProgressNoteEditPhotoState oldPhotoState,
    CompletedPhotoUploadState uploadState,
  ) async* {
    try {
      if (state is ExistingNoteEditState) {
        final state = this.state as ExistingNoteEditState;
        final newNote = state.savedNote.withNewPhoto(uploadState.url);
        await notesRepository.updateNote(newNote);
        yield ExistingNoteEditState(newNote);
      }
      final newPhotoState = CompletedNoteEditPhotoState(uploadState.url, oldPhotoState.file);
      yield* _mapPhotoStateUpdate(oldPhotoState, newPhotoState);
    } catch (e) {
      yield* _mapFailedPhotoUploadUpdatedToState(oldPhotoState, FailedPhotoUploadState());
    }
  }

  Stream<NoteEditState> _mapInProgressPhotoUploadUpdatedToState(
    InProgressNoteEditPhotoState oldPhotoState,
    InProgressPhotoUploadState uploadState,
  ) async* {
    final newPhotoState = InProgressNoteEditPhotoState(
      oldPhotoState.file,
      oldPhotoState.task,
      oldPhotoState.subscription,
      uploadState.progress,
    );
    yield* _mapPhotoStateUpdate(oldPhotoState, newPhotoState);
  }

  Stream<NoteEditState> _mapFailedPhotoUploadUpdatedToState(
    InProgressNoteEditPhotoState oldPhotoState,
    FailedPhotoUploadState uploadState,
  ) async* {
    final newPhotoState = FailedNoteEditPhotoState(oldPhotoState.file);
    yield* _mapPhotoStateUpdate(oldPhotoState, newPhotoState);
  }

  Stream<NoteEditState> _mapCancelPhotoUploadToState(CancelPhotoUploadNoteEditEvent event) async* {
    final photoState = state.photos.firstWhere(
      (photo) => photo is InProgressNoteEditPhotoState && photo.task == event.task,
      orElse: null,
    ) as InProgressNoteEditPhotoState;
    if (photoState == null) return;

    photoState.subscription.cancel();
    photoState.task.cancel();
    yield* _mapPhotoStateUpdate(photoState, null);
  }

  Stream<NoteEditState> _mapRetryPhotoUploadToState(RetryPhotoUploadNoteEditEvent event) async* {
    final photoState = state.photos.firstWhere(
      (photo) => photo is FailedNoteEditPhotoState && photo.file == event.file,
      orElse: null,
    ) as FailedNoteEditPhotoState;
    if (photoState == null) return;

    yield* _mapStartUploadTaskToState(photoState, photoState.file);
  }

  Stream<NoteEditState> _mapStartUploadTaskToState(NoteEditPhotoState previousState, File file) async* {
    final task = await photoApi.uploadPhoto(file);
    // ignore: cancel_subscriptions
    StreamSubscription subscription = task.stateStream.listen((event) {
      add(PhotoUploadUpdatedNoteEditEvent(task, event));
    });
    yield* _mapPhotoStateUpdate(previousState, InProgressNoteEditPhotoState(file, task, subscription, 0));
  }

  Stream<NoteEditState> _mapPhotoStateUpdate(
    NoteEditPhotoState oldPhotoState,
    NoteEditPhotoState newPhotoState,
  ) async* {
    final newPhotos = [...state.photos];
    if (oldPhotoState != null) newPhotos.remove(oldPhotoState);
    if (newPhotoState != null) newPhotos.add(newPhotoState);
    yield state.withPhotos(newPhotos);
  }

  Stream<NoteEditState> _mapCatching(Stream<NoteEditState> Function() operation) async* {
    final previousState = state;
    try {
      await for (var value in operation()) yield value;
    } on ApiConnectionException {
      yield* _mapErrorToState(previousState, NoteEditStateError.network);
    } catch (e, s) {
      print('$e\n$s');
      yield* _mapErrorToState(previousState, NoteEditStateError.other);
    }
  }

  Stream<NoteEditState> _mapErrorToState(NoteEditState baseState, NoteEditStateError error) async* {
    yield baseState.withError(error);
    yield baseState;
  }
}
