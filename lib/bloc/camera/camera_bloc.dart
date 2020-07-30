import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/camera/camera_event.dart';
import 'package:notepad/bloc/camera/camera_state.dart';
import 'package:path_provider/path_provider.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(UninitializedCameraState()) {
    add(FetchCamerasCameraEvent());
  }

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) =>
      _mapCatching(() async* {
        if (event is FetchCamerasCameraEvent)
          yield* _mapFetchCamerasToState();
        else if (event is SelectNextCameraCameraEvent)
          yield* _mapSelectNextCameraToState();
        else if (event is TakePhotoCameraEvent)
          yield* _mapTakePhotoToState();
        else if (event is DismissPhotoCameraEvent)
          yield* _mapDismissPhotoToState();
      });

  Stream<CameraState> _mapFetchCamerasToState() async* {
    final newCameras = await availableCameras();
    if (state is UninitializedCameraState) {
      yield* _mapInitializeDefaultCameraToState(newCameras);
    } else if (state is InitializedCameraState) {
      final state = this.state as InitializedCameraState;

      final indexOfCurrentCameraInNewCameras =
          newCameras.indexOf(state.currentCamera);
      if (indexOfCurrentCameraInNewCameras != -1)
        yield InitializedCameraState(
            newCameras, indexOfCurrentCameraInNewCameras, state.controller);
      else
        yield* _mapInitializeDefaultCameraToState(newCameras);
    }
  }

  Stream<CameraState> _mapSelectNextCameraToState() async* {
    if (this.state is! InitializedCameraState) return;
    final state = this.state as InitializedCameraState;

    int newCameraIndex = state.currentCameraIndex + 1;
    if (newCameraIndex >= state.cameras.length) newCameraIndex = 0;

    yield* _mapInitializeCameraToState(state.cameras, newCameraIndex);
  }

  Stream<CameraState> _mapInitializeDefaultCameraToState(
      List<CameraDescription> newCameras) async* {
    final defaultCamera = _getDefaultCamera(newCameras);
    if (defaultCamera == null)
      yield ErrorCameraState(CameraError.no_cameras);
    else {
      final defaultCameraIndex = newCameras.indexOf(defaultCamera);
      yield* _mapInitializeCameraToState(newCameras, defaultCameraIndex);
    }
  }

  Stream<CameraState> _mapInitializeCameraToState(
      List<CameraDescription> cameras, int cameraIndex) async* {
    _disposeControllerIfInitialized();
    final newCamera = cameras[cameraIndex];
    yield InitializingCameraState(cameras, cameraIndex);
    final controller = CameraController(newCamera, ResolutionPreset.high);
    await controller.initialize();
    yield InitializedCameraState(cameras, cameraIndex, controller);
  }

  Stream<CameraState> _mapTakePhotoToState() async* {
    if (this.state is! InitializedCameraState) return;
    final state = this.state as InitializedCameraState;

    Directory tempDir = await getTemporaryDirectory();
    String filename = DateTime.now().toIso8601String();
    String path = '${tempDir.path}/$filename';
    await state.controller.takePicture(path);
    yield PhotoTakenCameraState(
        state.cameras, state.currentCameraIndex, state.controller, path);
  }

  Stream<CameraState> _mapDismissPhotoToState() async* {
    if (this.state is! PhotoTakenCameraState) return;
    final state = this.state as PhotoTakenCameraState;

    await File(state.photoPath).delete();
    yield InitializedCameraState(
        state.cameras, state.currentCameraIndex, state.controller);
  }

  Future<void> _disposeControllerIfInitialized() async {
    if (state is InitializedCameraState)
      await (state as InitializedCameraState).controller.dispose();
  }

  Stream<CameraState> _mapCatching(
      Stream<CameraState> Function() operation) async* {
    try {
      await for (var value in operation()) yield value;
    } on Exception {
      yield ErrorCameraState(CameraError.other);
    }
  }

  CameraDescription _getDefaultCamera(List<CameraDescription> cameras) =>
      cameras.isNotEmpty
          ? cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first,
            )
          : null;

  @override
  Future<void> close() async {
    _disposeControllerIfInitialized();
    await super.close();
  }
}
