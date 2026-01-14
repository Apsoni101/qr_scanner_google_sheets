part of 'qr_result_confirmation_bloc.dart';

class QrResultConfirmationState extends Equatable {
  final bool isLoadingSheets;
  final bool isCreatingSheet;
  final bool isSavingScan;
  final bool isCreatingNewSheet;
  final String newSheetName;
  final String? selectedSheetId;
  final List<SheetEntity> sheets;
  final String? sheetsLoadError;
  final String? sheetCreationError;
  final String? scanSaveError;
  final bool isScanSaved;
  final bool isCachedData; // Indicates if data is from local cache

  const QrResultConfirmationState({
    this.isLoadingSheets = false,
    this.isCreatingSheet = false,
    this.isSavingScan = false,
    this.isCreatingNewSheet = false,
    this.newSheetName = '',
    this.selectedSheetId,
    this.sheets = const <SheetEntity>[],
    this.sheetsLoadError,
    this.sheetCreationError,
    this.scanSaveError,
    this.isScanSaved = false,
    this.isCachedData = false,
  });

  QrResultConfirmationState copyWith({
    bool? isLoadingSheets,
    bool? isCreatingSheet,
    bool? isSavingScan,
    bool? isCreatingNewSheet,
    String? newSheetName,
    String? selectedSheetId,
    List<SheetEntity>? sheets,
    String? sheetsLoadError,
    String? sheetCreationError,
    String? scanSaveError,
    bool? isScanSaved,
    bool? isCachedData,
  }) {
    return QrResultConfirmationState(
      isLoadingSheets: isLoadingSheets ?? this.isLoadingSheets,
      isCreatingSheet: isCreatingSheet ?? this.isCreatingSheet,
      isSavingScan: isSavingScan ?? this.isSavingScan,
      isCreatingNewSheet: isCreatingNewSheet ?? this.isCreatingNewSheet,
      newSheetName: newSheetName ?? this.newSheetName,
      selectedSheetId: selectedSheetId ?? this.selectedSheetId,
      sheets: sheets ?? this.sheets,
      sheetsLoadError: sheetsLoadError,
      sheetCreationError: sheetCreationError,
      scanSaveError: scanSaveError,
      isScanSaved: isScanSaved ?? this.isScanSaved,
      isCachedData: isCachedData ?? this.isCachedData,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingSheets,
    isCreatingSheet,
    isSavingScan,
    isCreatingNewSheet,
    newSheetName,
    selectedSheetId,
    sheets,
    sheetsLoadError,
    sheetCreationError,
    scanSaveError,
    isScanSaved,
    isCachedData,
  ];
}

class QrResultConfirmationInitial extends QrResultConfirmationState {
  const QrResultConfirmationInitial();
}