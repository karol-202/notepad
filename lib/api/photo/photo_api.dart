import 'dart:io';

import 'package:notepad/api/photo/photo_update_state.dart';

abstract class PhotoApi {
  Future<PhotoUploadTask> uploadPhoto(File file);

  void dispose() {}
}

abstract class PhotoUploadTask {
  Stream<PhotoUploadState> get stateStream;

  void cancel();
}
