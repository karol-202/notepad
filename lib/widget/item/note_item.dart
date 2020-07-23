import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notepad/model/note.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  final bool selected;
  final bool selectionMode;
  final void Function() onEdit;
  final void Function() onSelectionToggle;
  final void Function() onDelete;

  NoteWidget({
    @required this.note,
    this.selected = false,
    this.selectionMode = false,
    this.onEdit,
    this.onSelectionToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
      child: ListTile(
        onTap: selected ? onSelectionToggle : onEdit,
        onLongPress: onSelectionToggle,
        leading: selectionMode ? _selectionMarker(context) : null,
        title: Text(note.title),
        subtitle: Text(note.content),
      ),
    );
  }

  Widget _selectionMarker(BuildContext context) => GestureDetector(
        onTap: onSelectionToggle,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? Theme.of(context).primaryColorDark : Colors.transparent,
            border: selected
                ? null
                : Border.all(
                    color: Theme.of(context).primaryColorDark,
                    width: 2.0,
                  ),
          ),
          width: 40,
          height: 40,
          child: selected
              ? Icon(
                  Icons.done,
                  color: Theme.of(context).primaryIconTheme.color,
                )
              : null,
        ),
      );
}
