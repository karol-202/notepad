import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/bloc/camera/camera_state.dart';
import 'package:notepad/bloc/note_edit/note_edit_bloc.dart';
import 'package:notepad/bloc/note_edit/note_edit_event.dart';
import 'package:notepad/bloc/note_edit/note_edit_state.dart';
import 'package:notepad/model/note.dart';
import 'package:notepad/util/diamond_notched_shape.dart';
import 'package:notepad/widget/bottom_bar_action.dart';
import 'package:notepad/widget/screen/camera_screen_route.dart';
import 'package:progress_dialog/progress_dialog.dart';

class NoteEditScreen extends StatefulWidget {
  NoteEditScreen();

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    final note = context.bloc<NoteEditBloc>().state.savedNote;
    _titleController.text = note?.title ?? '';
    _contentController.text = note?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteEditBloc, NoteEditState>(
      listener: (context, editState) => _onEditStateChange(context, editState),
      builder: (context, editState) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: TextField(
            controller: _titleController,
            onChanged: (_) => _edit(),
            decoration: null,
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: DiamondNotchedShape(),
          notchMargin: 8,
          child: Row(
            children: [
              BottomBarAction(
                icon: Icons.camera_alt,
                onPressed: _takePhoto,
              ),
              Spacer(),
              BottomBarAction(
                icon: Icons.delete,
                onPressed: editState.canDelete ? () => _delete() : null,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _toggleEditing(context, editState),
          elevation: 0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Icon(editState.editStatus == NoteEditStateEditStatus.editing ? Icons.done : Icons.edit),
        ),
        body: Column(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black87,
                    width: 0.0,
                  ),
                ),
              ),
              child: Material(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.text_format),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.text_format),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _contentController,
                  onChanged: (_) => _edit(),
                  decoration: null,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onEditStateChange(BuildContext context, NoteEditState editState) {
    if (editState.error != null) _showFailureSnackbar(_getNotesErrorText(editState.error));
    if (editState.editStatus != NoteEditStateEditStatus.saving &&
        editState.deleteStatus != NoteEditStateDeleteStatus.deleting) _hideProgressDialogIfVisible();
    if (editState.editStatus == NoteEditStateEditStatus.saving && _progressDialog == null)
      _showProgressDialog();
    if (editState.deleteStatus == NoteEditStateDeleteStatus.deleting && _progressDialog == null)
      _showProgressDialog();
    if (editState.deleteStatus == NoteEditStateDeleteStatus.deleted) _exit();
  }

  void _toggleEditing(BuildContext context, NoteEditState state) {
    if (state.editStatus == NoteEditStateEditStatus.idle)
      _edit();
    else if (state.editStatus == NoteEditStateEditStatus.editing) _save();
  }

  void _edit() => context.bloc<NoteEditBloc>().add(EditNoteEditEvent());

  void _save() => context.bloc<NoteEditBloc>().add(SaveNoteEditEvent(Note(
        title: _titleController.value.text,
        content: _contentController.value.text,
      )));

  void _delete() => context.bloc<NoteEditBloc>().add(DeleteNoteEditEvent());

  void _showProgressDialog() {
    _progressDialog = ProgressDialog(context);
    _progressDialog.show();
  }

  void _hideProgressDialogIfVisible() {
    _progressDialog?.hide();
    _progressDialog = null;
  }

  void _showFailureSnackbar(String error) => _scaffoldKey.currentState
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(error),
        behavior: SnackBarBehavior.floating,
      ),
    );

  String _getNotesErrorText(NoteEditStateError error) {
    switch (error) {
      case NoteEditStateError.network:
        return "Błąd połączenia";
      default:
        return "Nieznany błąd";
    }
  }

  String _getCameraErrorText(CameraError error) {
    switch (error) {
      case CameraError.no_cameras:
        return "Brak aparatu";
      default:
        return "Błąd aparatu";
    }
  }

  void _takePhoto() => Navigator.of(context).pushNamed(CameraScreenRoute.ROUTE,
      arguments: CameraScreenArgs(
        onPhotoSubmit: _onPhotoTaken,
        onError: (error) => _showFailureSnackbar(_getCameraErrorText(error)),
      ));

  void _onPhotoTaken(String path) {
    print("photo: $path");
  }

  void _exit() => Navigator.of(context).pop();
}
