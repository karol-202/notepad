import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/auth/auth_bloc.dart';
import 'package:notepad/bloc/auth/auth_event.dart';
import 'package:notepad/bloc/notes/notes_bloc.dart';
import 'package:notepad/bloc/notes/notes_event.dart';
import 'package:notepad/bloc/notes/notes_state.dart';
import 'package:notepad/bloc/notes_selection/notes_selection_bloc.dart';
import 'package:notepad/bloc/notes_selection/notes_selection_event.dart';
import 'package:notepad/bloc/notes_selection/notes_selection_state.dart';
import 'package:notepad/model/note.dart';
import 'package:notepad/util/diamond_notched_shape.dart';
import 'package:notepad/widget/auth_listener.dart';
import 'package:notepad/widget/bottom_bar_action.dart';
import 'package:notepad/widget/dialog/note_delete_dialog.dart';
import 'package:notepad/widget/item/note_item.dart';
import 'package:notepad/widget/screen/auth_screen.dart';
import 'package:notepad/widget/screen/note_edit_screen_route.dart';

class NotesScreen extends StatefulWidget {
  static const ROUTE = "/notes";

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _refreshCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    context.bloc<NotesBloc>().add(RefreshNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AuthListener(
        onLogout: _onLogout,
        builder: (user) => BlocConsumer<NotesBloc, NotesState>(
          listener: (context, notesState) => _onNotesStateChange(context, notesState),
          builder: (context, notesState) => BlocBuilder<NotesSelectionBloc, NotesSelectionState>(
            builder: (context, selectionState) {
              final selectedNotes = notesState.getNotesByIds(selectionState.selectedIds);
              return Scaffold(
                key: _scaffoldKey,
                body: RefreshIndicator(
                  onRefresh: () {
                    context.bloc<NotesBloc>().add(RefreshNotesEvent());
                    return _refreshCompleter.future;
                  },
                  child: ListView.builder(
                    itemCount: notesState.notesCount,
                    itemBuilder: (_, index) {
                      final note = notesState.notes[index];
                      return NoteWidget(
                        note: note,
                        selected: selectionState.isSelected(note.id),
                        selectionMode: selectionState.isSelectionMode,
                        onEdit: () => _editExistingNote(note),
                        onSelectionToggle: () =>
                            context.bloc<NotesSelectionBloc>().add(ToggleNotesSelectionEvent(note.id)),
                        onDelete: () => _showNoteDeleteDialog(context, note),
                      );
                    },
                  ),
                ),
                drawer: Drawer(
                    child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountEmail: Text(user.email ?? ''),
                      accountName: Text(user.displayName ?? ''),
                      currentAccountPicture: user.photoUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(user.photoUrl),
                            )
                          : null,
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text("Wyloguj"),
                      onTap: _logout,
                    )
                  ],
                )),
                bottomNavigationBar: BottomAppBar(
                  shape: DiamondNotchedShape(),
                  notchMargin: 8,
                  child: Row(
                    children: selectionState.isSelectionMode
                        ? [
                            BottomBarAction(
                              icon: Icons.clear,
                              onPressed: () =>
                                  context.bloc<NotesSelectionBloc>().add(ClearNotesSelectionEvent()),
                            ),
                            Spacer(),
                            BottomBarAction(
                              icon: Icons.delete,
                              onPressed: () => _showSelectedNotesDeleteDialog(context, selectedNotes),
                            ),
                          ]
                        : [
                            Builder(
                              builder: (ctx) => BottomBarAction(
                                icon: Icons.menu,
                                onPressed: () => Scaffold.of(ctx).openDrawer(),
                              ),
                            ),
                            Spacer(),
                            BottomBarAction(
                              icon: Icons.delete_sweep,
                              onPressed: notesState.notes.isNotEmpty
                                  ? () => _showAllNotesDeleteDialog(context, notesState.notes)
                                  : null,
                            ),
                          ],
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _editNewNote(),
                  elevation: 0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Icon(Icons.add),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onNotesStateChange(BuildContext context, NotesState notesState) {
    if (notesState is! LoadingNotesState) _resetRefreshCompleter();
    if (notesState is FailureNotesState) _showFailureSnackbar(context, notesState.error);
  }

  void _resetRefreshCompleter() {
    _refreshCompleter.complete();
    _refreshCompleter = Completer();
  }

  void _showFailureSnackbar(BuildContext context, NotesStateError error) =>
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(_getNotesErrorText(error)),
          behavior: SnackBarBehavior.floating,
        ),
      );

  // ignore: missing_return
  String _getNotesErrorText(NotesStateError error) {
    switch (error) {
      case NotesStateError.network:
        return "Błąd połączenia";
      case NotesStateError.other:
        return "Nieznany błąd";
    }
  }

  void _showNoteDeleteDialog(BuildContext context, Note note) => _showDeleteDialog(
        context,
        [note],
        () => context.bloc<NotesBloc>().add(DeleteNoteNotesEvent(note.id)),
      );

  void _showSelectedNotesDeleteDialog(BuildContext context, List<Note> notes) => _showDeleteDialog(
        context,
        notes,
        () => context.bloc<NotesBloc>().add(DeleteNotesNotesEvent(notes.map((note) => note.id))),
      );

  void _showAllNotesDeleteDialog(BuildContext context, List<Note> notes) => _showDeleteDialog(
        context,
        notes,
        () => context.bloc<NotesBloc>().add(DeleteAllNotesEvent()),
      );

  void _showDeleteDialog(BuildContext context, List<Note> notes, void Function() onDelete) {
    showDialog(
      context: context,
      builder: (ctx) => NoteDeleteDialog(
        notes: notes,
        onDelete: onDelete,
      ),
    );
  }

  void _editNewNote() => _editExistingNote(null);

  void _editExistingNote(Note note) =>
      Navigator.of(context).pushNamed(NoteEditScreenRoute.ROUTE, arguments: NoteEditScreenArgs(note));

  void _logout() => context.bloc<AuthBloc>().add(LogoutAuthEvent());

  void _onLogout() => Navigator.of(context).popUntil(ModalRoute.withName(AuthScreen.ROUTE));
}
