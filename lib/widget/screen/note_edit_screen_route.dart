import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/note_edit/note_edit_bloc.dart';
import 'package:notepad/model/note.dart';
import 'package:notepad/widget/screen/note_edit_screen.dart';

class NoteEditScreenArgs {
  final Note initialNote;

  NoteEditScreenArgs(this.initialNote);
}

class NoteEditScreenRoute extends StatelessWidget {
  static const ROUTE = "/note-edit";

  final NoteEditBlocFactory noteEditBlocFactory;

  NoteEditScreenRoute(this.noteEditBlocFactory);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as NoteEditScreenArgs;
    return BlocProvider(
      create: (_) => noteEditBlocFactory.create(args.initialNote),
      child: NoteEditScreen(),
    );
  }
}
