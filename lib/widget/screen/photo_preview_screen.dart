import 'dart:io';

import 'package:flutter/material.dart';

class PhotoPreviewScreen extends StatelessWidget {
  final String photoPath;
  final void Function() onSubmit;
  final void Function() onDismiss;

  PhotoPreviewScreen({
    @required this.photoPath,
    @required this.onSubmit,
    @required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _dismiss(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () => _submit(context),
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Image.file(
          File(photoPath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    onSubmit();
    Navigator.of(context).pop();
  }

  void _dismiss(BuildContext context) {
    onDismiss();
    Navigator.of(context).pop();
  }
}
