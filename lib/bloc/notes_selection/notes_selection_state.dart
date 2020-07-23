import 'package:equatable/equatable.dart';

class NotesSelectionState extends Equatable {
  final List<String> selectedIds;

  const NotesSelectionState(this.selectedIds);

  @override
  List<Object> get props => [selectedIds];

  bool get isSelectionMode => selectedIds.isNotEmpty;

  bool isSelected(String id) => selectedIds.contains(id);
}
