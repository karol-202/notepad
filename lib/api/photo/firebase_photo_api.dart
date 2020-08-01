import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:notepad/api/photo/photo_api.dart';
import 'package:notepad/api/photo/photo_update_state.dart';
import 'package:notepad/repository/auth/auth_repository.dart';

class FirebasePhotoApi extends PhotoApi {
  final AuthRepository authRepository;

  final storageRef = FirebaseStorage.instance.ref();

  FirebasePhotoApi(this.authRepository);

  @override
  Future<PhotoUploadTask> uploadPhoto(File file) async {
    try {
      final photosRef = await _getPhotosRef();
      final filename = file.uri.pathSegments.last;
      final task = photosRef.child(filename).putFile(file);
      return InProgressPhotoUploadTask(task);
    } catch (e) {
      return FailedPhotoUploadTask();
    }
  }

  Future<StorageReference> _getPhotosRef() async =>
      storageRef.child('users').child(await _getUserId()).child('photos');

  Future<String> _getUserId() async => (await authRepository.getAuthState().first).id;
}

class InProgressPhotoUploadTask extends PhotoUploadTask {
  final StorageUploadTask _task;

  InProgressPhotoUploadTask(this._task);

  Stream<PhotoUploadState> get stateStream =>
      _task.events.asyncMap((event) async => await _storageEventToState(event));

  Future<PhotoUploadState> _storageEventToState(StorageTaskEvent event) async {
    if (event.type == StorageTaskEventType.success) {
      final url = await event.snapshot.ref.getDownloadURL() as String;
      return CompletedPhotoUploadState(url);
    } else if (event.type == StorageTaskEventType.failure)
      return FailedPhotoUploadState();
    else
      return InProgressPhotoUploadState(
          event.snapshot.bytesTransferred / (event.snapshot.totalByteCount as double));
  }

  void cancel() => _task.cancel();
}

class FailedPhotoUploadTask extends PhotoUploadTask {
  Stream<PhotoUploadState> get stateStream => Stream.value(FailedPhotoUploadState());

  void cancel() {}
}
