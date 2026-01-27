part of 'sheet_selection_bloc.dart';

@immutable
sealed class SheetSelectionEvent extends Equatable {
  const SheetSelectionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class OnConfirmationLoadSheets extends SheetSelectionEvent {
  const OnConfirmationLoadSheets();
}

final class OnConfirmationLoadMoreSheets extends SheetSelectionEvent {
  const OnConfirmationLoadMoreSheets();
}

final class OnConfirmationSheetSelected extends SheetSelectionEvent {
  const OnConfirmationSheetSelected(this.sheetId);

  final String sheetId;

  @override
  List<Object?> get props => <Object?>[sheetId];
}

final class OnConfirmationSheetNameChanged extends SheetSelectionEvent {
  const OnConfirmationSheetNameChanged(this.sheetName);

  final String sheetName;

  @override
  List<Object?> get props => <Object?>[sheetName];
}

final class OnConfirmationModeToggled extends SheetSelectionEvent {
  const OnConfirmationModeToggled({required this.isCreating});

  final bool isCreating;

  @override
  List<Object?> get props => <Object?>[isCreating];
}

final class OnConfirmationCreateSheet extends SheetSelectionEvent {
  const OnConfirmationCreateSheet();
}

class OnConfirmationSaveScan extends SheetSelectionEvent {
  const OnConfirmationSaveScan(this.scanEntity, this.sheetId, this.sheetTitle);

  final ScanResultEntity scanEntity;
  final String sheetId;
  final String sheetTitle;
}
