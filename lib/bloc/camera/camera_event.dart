import 'package:equatable/equatable.dart';

abstract class CameraEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCamerasCameraEvent extends CameraEvent {}

class SelectNextCameraCameraEvent extends CameraEvent {}

class TakePhotoCameraEvent extends CameraEvent {}

class DismissPhotoCameraEvent extends CameraEvent {}
