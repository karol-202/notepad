import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class CameraState extends Equatable {}

class UninitializedCameraState extends CameraState {
  @override
  List<Object> get props => [];
}

class InitializingCameraState extends CameraState {
  final List<CameraDescription> cameras;
  final int currentCamera;

  InitializingCameraState(this.cameras, this.currentCamera);

  @override
  List<Object> get props => [cameras, currentCamera];
}

class InitializedCameraState extends CameraState {
  final List<CameraDescription> cameras;
  final int currentCameraIndex;
  final CameraController controller;

  InitializedCameraState(
    this.cameras,
    this.currentCameraIndex,
    this.controller,
  );

  @override
  List<Object> get props => [cameras, currentCameraIndex, controller];

  CameraDescription get currentCamera => cameras[currentCameraIndex];
  double get aspectRatio => controller.value.aspectRatio;
}

class PhotoTakenCameraState extends CameraState {
  final List<CameraDescription> cameras;
  final int currentCameraIndex;
  final CameraController controller;
  final String photoPath;

  PhotoTakenCameraState(
    this.cameras,
    this.currentCameraIndex,
    this.controller,
    this.photoPath,
  );

  @override
  List<Object> get props =>
      [cameras, currentCameraIndex, controller, photoPath];
}

class ErrorCameraState extends CameraState {
  final CameraError error;

  ErrorCameraState(this.error);

  @override
  List<Object> get props => [error];
}

enum CameraError { no_cameras, other }
