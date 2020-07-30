import 'package:flutter/material.dart';
import 'package:notepad/widget/screen/photo_preview_screen.dart';

class PhotoPreviewScreenArgs {
  final String photoPath;
  final void Function() onSubmit;
  final void Function() onDismiss;

  PhotoPreviewScreenArgs({
    @required this.photoPath,
    @required this.onSubmit,
    @required this.onDismiss,
  });
}

class PhotoPreviewScreenRoute extends StatelessWidget {
  static const ROUTE = "/photo-preview";

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as PhotoPreviewScreenArgs;
    return PhotoPreviewScreen(
      photoPath: args.photoPath,
      onSubmit: args.onSubmit,
      onDismiss: args.onDismiss,
    );
  }
}
