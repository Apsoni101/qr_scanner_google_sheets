import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';
import 'package:qr_scanner_practice/core/di/app_injector.dart';
import 'package:qr_scanner_practice/core/extensions/color_extension.dart';
import 'package:qr_scanner_practice/core/extensions/localization_extension.dart';
import 'package:qr_scanner_practice/core/navigation/app_router.gr.dart';
import 'package:qr_scanner_practice/feature/qr_scan/presentation/bloc/qr_result_bloc/qr_result_bloc.dart';

@RoutePage()
class QrResultScreen extends StatelessWidget {
  const QrResultScreen({required this.qrData, super.key});

  final String qrData;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<QrResultBloc>(
      create: (final BuildContext context) => AppInjector.getIt<QrResultBloc>(),
      child: _QrResultView(qrData: qrData),
    );
  }
}

class _QrResultView extends StatefulWidget {
  const _QrResultView({required this.qrData});

  final String qrData;

  @override
  State<_QrResultView> createState() => _QrResultViewState();
}

class _QrResultViewState extends State<_QrResultView> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.white,
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const _SuccessIcon(),
          const SizedBox(height: 24),
          _QrDataSection(qrData: widget.qrData),
          const SizedBox(height: 24),
          _CommentSection(commentController: _commentController),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: _ActionButtons(
          commentController: _commentController,
          qrData: widget.qrData,
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
        context.locale.qrCodeDetailsTitle,
        style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
          color: context.appColors.black,
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 40,
        backgroundColor: context.appColors.c3BA935,
        child: Icon(Icons.check, size: 48, color: context.appColors.white),
      ),
    );
  }
}

class _QrDataSection extends StatelessWidget {
  const _QrDataSection({required this.qrData});

  final String qrData;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionLabel(label: context.locale.scannedDataTitle),
        const SizedBox(height: 8),
        _DataContainer(
          child: Text(
            qrData,
            style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
              color: context.appColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _CommentSection extends StatelessWidget {
  const _CommentSection({required this.commentController});

  final TextEditingController commentController;

  @override
  Widget build(final BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionLabel(label: context.locale.addCommentTitle),
        _CommentTextField(controller: commentController),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(final BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
        color: context.appColors.slate,
      ),
    );
  }
}

class _DataContainer extends StatelessWidget {
  const _DataContainer({required this.child});

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.cEAECF0),
      ),
      child: child,
    );
  }
}

class _CommentTextField extends StatelessWidget {
  const _CommentTextField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(final BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (final String value) {
        context.read<QrResultBloc>().add(OnResultCommentChanged(value));
      },
      maxLines: 4,
      style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
        color: context.appColors.black,
      ),
      decoration: _buildInputDecoration(context),
    );
  }

  InputDecoration _buildInputDecoration(final BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(12);
    final BorderSide normalBorder = BorderSide(
      color: context.appColors.cEAECF0,
    );
    final BorderSide focusedBorder = BorderSide(
      color: context.appColors.primaryBlue,
      width: 2,
    );

    return InputDecoration(
      hintText: context.locale.commentHint,
      hintStyle: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
        color: context.appColors.slate,
      ),
      filled: true,
      fillColor: context.appColors.white,
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: normalBorder,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: normalBorder,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: focusedBorder,
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.commentController, required this.qrData});

  final TextEditingController commentController;
  final String qrData;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<QrResultBloc, QrResultState>(
      builder: (final BuildContext context, final QrResultState state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.router.maybePop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.appColors.black,
                    side: BorderSide(color: context.appColors.cEAECF0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.locale.cancelButton,
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      color: context.appColors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final String comment = state.comment;
                    context.router.push(
                      QrResultConfirmationRoute(
                        qrData: qrData,
                        comment: comment,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.primaryBlue,
                    foregroundColor: context.appColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.locale.saveButton,
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      color: context.appColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
