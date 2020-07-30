import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/camera/camera_bloc.dart';
import 'package:notepad/bloc/camera/camera_event.dart';
import 'package:notepad/bloc/camera/camera_state.dart';
import 'package:notepad/widget/screen/camera_screen.dart';

class CameraScreenArgs {
  final void Function(String) onPhotoSubmit;
  final void Function(CameraError) onError;

  CameraScreenArgs({
    @required this.onPhotoSubmit,
    @required this.onError,
  });
}

class CameraScreenRoute extends StatelessWidget {
  static const ROUTE = "/camera";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as CameraScreenArgs;
    return CameraScreen(
      onPhotoSubmit: args.onPhotoSubmit,
      onError: args.onError,
    );
  }
}
