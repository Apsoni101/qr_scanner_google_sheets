import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_practice/core/di/app_injector.dart';
import 'package:qr_scanner_practice/core/extensions/context_extensions.dart';
import 'package:qr_scanner_practice/feature/common/presentation/widgets/common_loading_view.dart';
import 'package:qr_scanner_practice/feature/home/presentation/widgets/home_screen_app_bar.dart';

import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/pending_sync_entity.dart';
import 'package:qr_scanner_practice/feature/view_scan_history/presentation/bloc/view_scans_history_screen_bloc.dart';
import 'package:qr_scanner_practice/feature/view_scan_history/presentation/widget/history_card_item.dart';
import 'package:qr_scanner_practice/feature/view_scan_history/presentation/widget/history_empty_view.dart';
import 'package:qr_scanner_practice/feature/view_scan_history/presentation/widget/history_error_view.dart';

@RoutePage()
class ViewScansHistoryScreen extends StatelessWidget {
  const ViewScansHistoryScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ViewScansHistoryScreenBloc>(
      create: (final BuildContext context) =>
          AppInjector.getIt<ViewScansHistoryScreenBloc>()
            ..add(const OnHistoryLoadScans()),
      child: const _ViewScansHistoryScreenBody(),
    );
  }
}

class _ViewScansHistoryScreenBody extends StatelessWidget {
  const _ViewScansHistoryScreenBody();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      body:
          BlocBuilder<ViewScansHistoryScreenBloc, ViewScansHistoryScreenState>(
            builder:
                (
                  final BuildContext context,
                  final ViewScansHistoryScreenState state,
                ) {
                  return switch ((
                    isLoading: state.isLoading,
                    hasError: state.error != null && state.error!.isNotEmpty,
                    isEmpty: state.filteredScans.isEmpty,
                  )) {
                    (isLoading: true, hasError: _, isEmpty: _) =>
                      const CommonLoadingView(),
                    (isLoading: false, hasError: true, isEmpty: _) =>
                      HistoryErrorState(errorMessage: state.error!),
                    (isLoading: false, hasError: false, isEmpty: true) =>
                      HistoryEmptyState(
                        isSearchActive: state.searchQuery.isNotEmpty,
                      ),
                    (isLoading: false, hasError: false, isEmpty: false) =>
                      RefreshIndicator(
                        onRefresh: () async {
                          context.read<ViewScansHistoryScreenBloc>().add(
                            const OnHistoryLoadScans(),
                          );
                        },
                        color: context.appColors.iconPrimary,
                        backgroundColor: context.appColors.textInversePrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.filteredScans.length,
                          itemBuilder:
                              (final BuildContext context, final int index) {
                                final PendingSyncEntity historyScan =
                                    state.filteredScans[index];
                                return HistoryCardItem(
                                  data: historyScan.scan.data,
                                  sheetTitle: historyScan.sheetTitle,
                                  timestamp: historyScan.scan.timestamp,
                                  comment: historyScan.scan.comment,
                                );
                              },
                        ),
                      ),
                  };
                },
          ),
    );
  }
}
