import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';
import 'package:qr_scanner_practice/core/di/app_injector.dart';
import 'package:qr_scanner_practice/core/extensions/color_extension.dart';
import 'package:qr_scanner_practice/core/extensions/date_time_extension.dart';
import 'package:qr_scanner_practice/core/extensions/localization_extension.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/sheet_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/presentation/bloc/qr_result_confirmation_bloc/qr_result_confirmation_bloc.dart';

@RoutePage()
class QrResultConfirmationScreen extends StatelessWidget {
  const QrResultConfirmationScreen({
    required this.qrData,
    required this.comment,
    super.key,
  });

  final String qrData;
  final String comment;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<QrResultConfirmationBloc>(
      create: (final BuildContext context) =>
          AppInjector.getIt<QrResultConfirmationBloc>(),
      child: _QrResultConfirmationView(qrData: qrData, comment: comment),
    );
  }
}

class _QrResultConfirmationView extends StatefulWidget {
  const _QrResultConfirmationView({
    required this.qrData,
    required this.comment,
  });

  final String qrData;
  final String comment;

  @override
  State<_QrResultConfirmationView> createState() =>
      _QrResultConfirmationViewState();
}

class _QrResultConfirmationViewState extends State<_QrResultConfirmationView> {
  late TextEditingController _sheetNameController;

  @override
  void initState() {
    super.initState();
    _sheetNameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<QrResultConfirmationBloc>().add(
          const OnConfirmationLoadSheets(),
        );
      }
    });
  }

  @override
  void dispose() {
    _sheetNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocListener<QrResultConfirmationBloc, QrResultConfirmationState>(
      listener:
          (final BuildContext context, final QrResultConfirmationState state) {
            if (state.scanSaveError != null) {
              _showSnackBar(
                context,
                state.scanSaveError!,
                context.appColors.red,
              );
            } else if (state.isScanSaved) {
              _showSnackBar(
                context,
                'Scan saved successfully!',
                context.appColors.c3BA935,
              );
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) {
                  context.router.maybePop();
                }
              });
            }
          },
      child: Scaffold(
        backgroundColor: context.appColors.white,
        appBar: _buildAppBar(context),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            _ScanDetailsSection(qrData: widget.qrData, comment: widget.comment),
            const SizedBox(height: 24),
            BlocSelector<
              QrResultConfirmationBloc,
              QrResultConfirmationState,
              bool
            >(
              selector: (final QrResultConfirmationState state) =>
                  state.isCreatingNewSheet,
              builder:
                  (final BuildContext context, final bool isCreatingNewSheet) {
                    return isCreatingNewSheet
                        ? _CreateNewSheetSection(
                            controller: _sheetNameController,
                          )
                        : const _SelectSheetSection();
                  },
            ),
            const SizedBox(height: 24),
            const _ModeToggleButton(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: _ConfirmationActionButtons(
            qrData: widget.qrData,
            comment: widget.comment,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(final BuildContext context) {
    return AppBar(
      backgroundColor: context.appColors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: context.appColors.black),
        onPressed: () => context.router.maybePop(),
      ),
      title: Text(
        'Confirm & Save',
        style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
          color: context.appColors.black,
        ),
      ),
    );
  }

  void _showSnackBar(
    final BuildContext context,
    final String message,
    final Color bgColor,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: bgColor));
  }
}

/// ============================================================================
/// SCAN DETAILS SECTION
/// ============================================================================
class _ScanDetailsSection extends StatelessWidget {
  const _ScanDetailsSection({required this.qrData, required this.comment});

  final String qrData;
  final String comment;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Scan Details',
          style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
            color: context.appColors.black,
          ),
        ),
        const SizedBox(height: 16),
        _DetailRow(label: context.locale.scannedDataTitle, value: qrData),
        const SizedBox(height: 12),
        _DetailRow(
          label: context.locale.addCommentTitle,
          value: comment.isEmpty ? context.locale.noCommentAdded : comment,
          isSubtle: comment.isEmpty,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isSubtle = false,
  });

  final String label;
  final String value;
  final bool isSubtle;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
            color: context.appColors.slate,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appColors.cEAECF0,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
              color: isSubtle
                  ? context.appColors.slate
                  : context.appColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

/// ============================================================================
/// SELECT SHEET SECTION
/// ============================================================================
class _SelectSheetSection extends StatelessWidget {
  const _SelectSheetSection();

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<
      QrResultConfirmationBloc,
      QrResultConfirmationState,
      ({bool isLoading, String? error, List<SheetEntity> sheets})
    >(
      selector: (final QrResultConfirmationState state) => (
        isLoading: state.isLoadingSheets,
        error: state.sheetsLoadError,
        sheets: state.sheets,
      ),
      builder:
          (
            final BuildContext context,
            final ({String? error, bool isLoading, List<SheetEntity> sheets})
            data,
          ) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Select Sheet',
                  style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                    color: context.appColors.slate,
                  ),
                ),
                const SizedBox(height: 12),
                if (data.isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: context.appColors.primaryBlue,
                    ),
                  )
                else if (data.error != null)
                  _ErrorContainer(message: data.error ?? '')
                else if (data.sheets.isEmpty)
                  const _EmptyStateContainer(
                    message: 'No sheets available. Create a new one!',
                  )
                else
                  _SheetsList(sheets: data.sheets),
              ],
            );
          },
    );
  }
}

class _SheetsList extends StatelessWidget {
  const _SheetsList({required this.sheets});

  final List<SheetEntity> sheets;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.cEAECF0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sheets.length,
        separatorBuilder: (final _, final __) =>
            Divider(height: 1, color: context.appColors.cEAECF0),
        itemBuilder: (final _, final int index) {
          final SheetEntity sheet = sheets[index];
          return _SheetItem(sheet: sheet);
        },
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  const _SheetItem({required this.sheet});

  final SheetEntity sheet;

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<
      QrResultConfirmationBloc,
      QrResultConfirmationState,
      String?
    >(
      selector: (final QrResultConfirmationState state) =>
          state.selectedSheetId,
      builder: (final BuildContext context, final String? selectedSheetId) {
        return RadioListTile<String>(
          value: sheet.id,
          groupValue: selectedSheetId,
          onChanged: (final String? value) {
            context.read<QrResultConfirmationBloc>().add(
              OnConfirmationSheetSelected(sheet.id),
            );
          },
          activeColor: context.appColors.primaryBlue,
          title: Text(
            sheet.title,
            style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
              color: context.appColors.black,
            ),
          ),
          subtitle: sheet.modifiedTime != null
              ? Text(
                  'Modified: ${sheet.modifiedTime.toFriendlyDate()}',
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.slate,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          selected: selectedSheetId == sheet.id,
          selectedTileColor: Colors.transparent,
        );
      },
    );
  }
}

// ============================================================================
// CREATE NEW SHEET SECTION
// ============================================================================
class _CreateNewSheetSection extends StatelessWidget {
  const _CreateNewSheetSection({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<
      QrResultConfirmationBloc,
      QrResultConfirmationState,
      ({bool isCreating, String? error})
    >(
      selector: (final QrResultConfirmationState state) =>
          (isCreating: state.isCreatingSheet, error: state.sheetCreationError),
      builder:
          (
            final BuildContext context,
            final ({String? error, bool isCreating}) data,
          ) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'New Sheet Name',
                  style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                    color: context.appColors.slate,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  enabled: !data.isCreating,
                  onChanged: (final String value) {
                    context.read<QrResultConfirmationBloc>().add(
                      OnConfirmationSheetNameChanged(value),
                    );
                  },
                  style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                    color: context.appColors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter sheet name (e.g., "Scans - Jan 2024")',
                    hintStyle: AppTextStyles.airbnbCerealW400S14Lh20Ls0
                        .copyWith(color: context.appColors.slate),
                    filled: true,
                    fillColor: context.appColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.appColors.cEAECF0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: context.appColors.cEAECF0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: context.appColors.primaryBlue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                if (data.error != null) ...<Widget>[
                  const SizedBox(height: 8),
                  _ErrorContainer(message: data.error ?? ''),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: data.isCreating
                        ? null
                        : () {
                            context.read<QrResultConfirmationBloc>().add(
                              const OnConfirmationCreateSheet(),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColors.primaryBlue,
                    ),
                    child: data.isCreating
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.appColors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Create Sheet',
                            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0
                                .copyWith(color: context.appColors.white),
                          ),
                  ),
                ),
              ],
            );
          },
    );
  }
}

// ============================================================================
// MODE TOGGLE BUTTON
// ============================================================================
class _ModeToggleButton extends StatelessWidget {
  const _ModeToggleButton();

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<
      QrResultConfirmationBloc,
      QrResultConfirmationState,
      bool
    >(
      selector: (final QrResultConfirmationState state) =>
          state.isCreatingNewSheet,
      builder: (final BuildContext context, final bool isCreatingNewSheet) {
        return InkWell(
          onTap: () {
            context.read<QrResultConfirmationBloc>().add(
              OnConfirmationModeToggled(!isCreatingNewSheet),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.appColors.cEAECF0.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  isCreatingNewSheet ? Icons.add_circle : Icons.list,
                  color: context.appColors.primaryBlue,
                ),
                const SizedBox(width: 12),
                Text(
                  isCreatingNewSheet
                      ? 'Switch to Select Sheet'
                      : 'Create New Sheet',
                  style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                    color: context.appColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// CONFIRMATION ACTION BUTTONS
// ============================================================================
class _ConfirmationActionButtons extends StatelessWidget {
  const _ConfirmationActionButtons({
    required this.qrData,
    required this.comment,
  });

  final String qrData;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      QrResultConfirmationBloc,
      QrResultConfirmationState,
      ({bool isLoading, bool canSave, bool isSaving})
    >(
      selector: (final QrResultConfirmationState state) {
        final bool isLoading =
            state.isSavingScan ||
            state.isCreatingSheet ||
            state.isLoadingSheets;

        final bool canSave =
            !isLoading &&
            state.selectedSheetId != null &&
            state.sheetsLoadError == null;

        return (
          isLoading: isLoading,
          canSave: canSave,
          isSaving: state.isSavingScan,
        );
      },
      builder:
          (
            final BuildContext context,
            final ({bool canSave, bool isLoading, bool isSaving}) data,
          ) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: data.isLoading
                        ? null
                        : () => context.router.maybePop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.appColors.cEAECF0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      context.locale.cancelButton,
                      style: AppTextStyles.airbnbCerealW500S14Lh20Ls0
                          .copyWith(color: context.appColors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  BlocSelector<
                    QrResultConfirmationBloc,
                    QrResultConfirmationState,
                    String?
                  >(
                    selector: (final QrResultConfirmationState state) =>
                        state.selectedSheetId,
                    builder:
                        (
                          final BuildContext context,
                          final String? selectedSheetId,
                        ) {
                          return ElevatedButton(
                            onPressed: data.canSave
                                ? () {
                                    final QrScanEntity scanEntity =
                                        QrScanEntity(
                                          qrData: qrData,
                                          comment: comment,
                                          timestamp: DateTime.now(),
                                          deviceId: null,
                                          userId: null,
                                        );

                                    context
                                        .read<QrResultConfirmationBloc>()
                                        .add(
                                          OnConfirmationSaveScan(
                                            scanEntity,
                                            selectedSheetId ?? '',
                                          ),
                                        );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  context.appColors.primaryBlue,
                              disabledBackgroundColor: context
                                  .appColors
                                  .slate
                                  .withOpacity(0.3),
                            ),
                            child: data.isSaving
                                ?  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                            context.appColors.white,
                                          ),
                                    ),
                                  )
                                : Text(
                                    context.locale.confirm,
                                    style: AppTextStyles
                                        .airbnbCerealW500S14Lh20Ls0
                                        .copyWith(
                                          color: context.appColors.white,
                                        ),
                                  ),
                          );
                        },
                  ),
                ],
              ),
            );
          },
    );
  }
}

/// ============================================================================
/// ERROR & EMPTY STATE CONTAINERS
/// ============================================================================
class _ErrorContainer extends StatelessWidget {
  const _ErrorContainer({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appColors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
          color: context.appColors.red,
        ),
      ),
    );
  }
}

class _EmptyStateContainer extends StatelessWidget {
  const _EmptyStateContainer({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appColors.cEAECF0,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
          color: context.appColors.slate,
        ),
      ),
    );
  }
}
