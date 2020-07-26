import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/auth/auth_bloc.dart';
import 'package:notepad/bloc/note_edit/note_edit_bloc.dart';
import 'package:notepad/bloc/notes/notes_bloc.dart';
import 'package:notepad/bloc/notes_selection/notes_selection_bloc.dart';
import 'package:notepad/widget/screen/auth_screen.dart';
import 'package:notepad/widget/screen/note_edit_screen_route.dart';

import 'screen/notes_screen.dart';

class Application extends StatelessWidget {
  final AuthBloc authBloc;
  final NotesBloc notesBloc;
  final NotesSelectionBloc notesSelectionBloc;
  final NoteEditBlocFactory noteEditBlocFactory;

  Application({
    @required this.authBloc,
    @required this.notesBloc,
    @required this.notesSelectionBloc,
    @required this.noteEditBlocFactory,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authBloc),
        BlocProvider(create: (_) => notesBloc),
        BlocProvider(create: (_) => notesSelectionBloc),
      ],
      child: MaterialApp(
        title: 'Notepad',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amber,
          bottomAppBarColor: Colors.green,
        ),
        routes: {
          AuthScreen.ROUTE: (_) => AuthScreen(),
          NotesScreen.ROUTE: (_) => NotesScreen(),
          NoteEditScreenRoute.ROUTE: (_) => NoteEditScreenRoute(noteEditBlocFactory),
        },
        initialRoute: AuthScreen.ROUTE,
      ),
    );
  }
}
