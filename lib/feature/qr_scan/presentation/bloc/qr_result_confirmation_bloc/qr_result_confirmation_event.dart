part of 'qr_result_confirmation_bloc.dart';

@immutable
sealed class QrResultConfirmationEvent extends Equatable {
  const QrResultConfirmationEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class OnConfirmationLoadSheets extends QrResultConfirmationEvent {
  const OnConfirmationLoadSheets();
}

final class OnConfirmationSheetSelected extends QrResultConfirmationEvent {
  const OnConfirmationSheetSelected(this.sheetId);

  final String sheetId;

  @override
  List<Object?> get props => <Object?>[sheetId];
}

final class OnConfirmationSheetNameChanged extends QrResultConfirmationEvent {
  const OnConfirmationSheetNameChanged(this.sheetName);

  final String sheetName;

  @override
  List<Object?> get props => <Object?>[sheetName];
}

final class OnConfirmationModeToggled extends QrResultConfirmationEvent {
  const OnConfirmationModeToggled(this.isCreating);

  final bool isCreating;

  @override
  List<Object?> get props => <Object?>[isCreating];
}

final class OnConfirmationCreateSheet extends QrResultConfirmationEvent {
  const OnConfirmationCreateSheet();
}

final class OnConfirmationSaveScan extends QrResultConfirmationEvent {
  const OnConfirmationSaveScan(this.scanEntity, this.sheetTitle);

  final QrScanEntity scanEntity;
  final String sheetTitle;

  @override
  List<Object?> get props => <Object?>[scanEntity, sheetTitle];
}
