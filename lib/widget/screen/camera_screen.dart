import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/camera/camera_bloc.dart';
import 'package:notepad/bloc/camera/camera_event.dart';
import 'package:notepad/bloc/camera/camera_state.dart';
import 'package:notepad/widget/screen/photo_preview_screen_route.dart';

class CameraScreen extends StatelessWidget {
  final void Function(String) onPhotoSubmit;
  final void Function(CameraError) onError;

  CameraScreen({
    @required this.onPhotoSubmit,
    @required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (_) => CameraBloc(),
        child: BlocConsumer<CameraBloc, CameraState>(
          listener: (context, cameraState) =>
              _onStateChange(context, cameraState),
          builder: (context, cameraState) =>
              cameraState is InitializedCameraState
                  ? Stack(
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: cameraState.aspectRatio,
                            child: CameraPreview(cameraState.controller),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.switch_camera),
                                      iconSize: 32,
                                      color: Colors.white,
                                      onPressed: () => _switchCamera(context),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 4,
                                        ),
                                      ),
                                      child: ClipPath(
                                        clipper: ShapeBorderClipper(
                                            shape: CircleBorder()),
                                        child: Material(
                                          child: InkResponse(
                                            onTap: () => _takePhoto(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
        ),
      ),
    );
  }

  void _onStateChange(BuildContext context, CameraState state) {
    if (state is PhotoTakenCameraState)
      _onPhotoTake(context, state.photoPath);
    else if (state is ErrorCameraState) _onError(context, state.error);
  }

  void _onPhotoTake(BuildContext context, String path) {
    Navigator.of(context).pushNamed(
      PhotoPreviewScreenRoute.ROUTE,
      arguments: PhotoPreviewScreenArgs(
        photoPath: path,
        onSubmit: () => _onPhotoSubmit(context, path),
        onDismiss: () => _onPhotoDismiss(context),
      ),
    );
  }

  void _onPhotoSubmit(BuildContext context, String path) {
    onPhotoSubmit(path);
    Navigator.of(context).pop();
  }

  void _onPhotoDismiss(BuildContext context) =>
      context.bloc<CameraBloc>().add(DismissPhotoCameraEvent());

  void _onError(BuildContext context, CameraError error) {
    onError(error);
    Navigator.of(context).pop();
  }

  void _switchCamera(BuildContext context) =>
      context.bloc<CameraBloc>().add(SelectNextCameraCameraEvent());

  void _takePhoto(BuildContext context) =>
      context.bloc<CameraBloc>().add(TakePhotoCameraEvent());
}
