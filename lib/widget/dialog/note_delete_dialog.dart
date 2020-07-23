import 'package:flutter/material.dart';
import 'package:notepad/model/note.dart';

class NoteDeleteDialog extends StatelessWidget {
  final List<Note> notes;
  final void Function() onDelete;

  NoteDeleteDialog({
    @required this.notes,
    @required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Czy chcesz usunąć ${notes.length} notatek?'),
      actions: [
        FlatButton(
          onPressed: () => _close(context),
          child: Text("ANULUJ"),
        ),
        FlatButton(
          onPressed: () => _deleteAndClose(context),
          child: Text("USUŃ"),
        ),
      ],
    );
  }

  void _deleteAndClose(BuildContext context) {
    onDelete();
    _close(context);
  }

  void _close(BuildContext context) => Navigator.of(context).pop();
}
