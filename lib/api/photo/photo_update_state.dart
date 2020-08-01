abstract class PhotoUploadState {}

class CompletedPhotoUploadState extends PhotoUploadState {
  final String url;

  CompletedPhotoUploadState(this.url);
}

class InProgressPhotoUploadState extends PhotoUploadState {
  final double progress;

  InProgressPhotoUploadState(this.progress);
}

class FailedPhotoUploadState extends PhotoUploadState {}
