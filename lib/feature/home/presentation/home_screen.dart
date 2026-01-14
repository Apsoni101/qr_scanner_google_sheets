import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';
import 'package:qr_scanner_practice/core/di/app_injector.dart';
import 'package:qr_scanner_practice/core/extensions/color_extension.dart';
import 'package:qr_scanner_practice/core/extensions/localization_extension.dart';
import 'package:qr_scanner_practice/core/navigation/app_router.gr.dart';
import 'package:qr_scanner_practice/feature/home/bloc/home_screen_bloc/home_screen_bloc.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeScreenBloc>(
      create: (context) => AppInjector.getIt<HomeScreenBloc>()
        ..add(const OnHomeLoadInitial()),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  @override
  void initState() {
    super.initState();
    // Listen for network status changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // You can integrate connectivity_plus or similar package here
      // For now, assume online
      context.read<HomeScreenBloc>().add(
        const OnHomeNetworkStatusChanged(true),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        // Show sync success message
        if (state.showSyncSuccess && state.pendingSyncCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('All scans synced successfully!'),
              backgroundColor: context.appColors.c3BA935,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Show sync error
        if (state.syncError != null && state.syncError!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.syncError!),
              backgroundColor: context.appColors.red,
            ),
          );
        }

        // Show general error
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: context.appColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.appColors.cF6F9FF,
        appBar: _buildAppBar(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                // Sync Status Banner
                BlocSelector<HomeScreenBloc, HomeScreenState,
                    ({int pendingCount, bool isOnline, bool isSyncing})>(
                  selector: (state) => (
                  pendingCount: state.pendingSyncCount,
                  isOnline: state.isOnline,
                  isSyncing: state.isSyncing,
                  ),
                  builder: (context, data) {
                    if (data.pendingCount > 0) {
                      return _buildSyncBanner(
                        context,
                        data.pendingCount,
                        data.isOnline,
                        data.isSyncing,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 32),
                // Main Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: context.appColors.cEBECFF,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 64,
                    color: context.appColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  context.locale.scanQrCode,
                  style:
                  AppTextStyles.airbnbCerealW700S24Lh32LsMinus1.copyWith(
                    color: context.appColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Subtitle
                Text(
                  context.locale.pointCameraToScanQr,
                  style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                    color: context.appColors.slate,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // Scan QR Button
                ElevatedButton.icon(
                  onPressed: () {
                    context.router.push(const QrScanningRoute());
                  },
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: context.appColors.white,
                  ),
                  label: Text(
                    context.locale.scanQrCode,
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      color: context.appColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.primaryBlue,
                    foregroundColor: context.appColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // History Button
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to history screen
                  },
                  icon: Icon(
                    Icons.history,
                    color: context.appColors.primaryBlue,
                  ),
                  label: Text(
                    context.locale.viewHistory,
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      color: context.appColors.primaryBlue,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.appColors.primaryBlue,
                    side: BorderSide(
                      color: context.appColors.primaryBlue,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.appColors.white,
      elevation: 0,
      title: Text(
        context.locale.qrScanner,
        style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
          color: context.appColors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        BlocSelector<HomeScreenBloc, HomeScreenState,
            ({int pendingCount, bool isSyncing})>(
          selector: (state) => (
          pendingCount: state.pendingSyncCount,
          isSyncing: state.isSyncing,
          ),
          builder: (context, data) {
            if (data.pendingCount > 0) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: data.isSyncing
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.appColors.primaryBlue,
                      ),
                    ),
                  )
                      : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${data.pendingCount}',
                      style: AppTextStyles.airbnbCerealW400S12Lh16
                          .copyWith(
                        color: context.appColors.red,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildSyncBanner(
      BuildContext context,
      int pendingCount,
      bool isOnline,
      bool isSyncing,
      ) {
    if (isSyncing) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.appColors.primaryBlue.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.appColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Syncing $pendingCount scan${pendingCount > 1 ? 's' : ''}...',
                style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                  color: context.appColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (!isOnline) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.appColors.red.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cloud_off,
              color: context.appColors.red,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offline Mode',
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      color: context.appColors.red,
                    ),
                  ),
                  Text(
                    '$pendingCount scan${pendingCount > 1 ? 's' : ''} waiting to sync',
                    style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                      color: context.appColors.slate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.c3BA935.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.appColors.c3BA935.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pendingCount Scan${pendingCount > 1 ? 's' : ''} to Sync',
                  style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                    color: context.appColors.c3BA935,
                  ),
                ),
                Text(
                  'Connection available - click to sync',
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.slate,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              context.read<HomeScreenBloc>().add(
                const OnHomeSyncPendingScans(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appColors.c3BA935,
              elevation: 0,
            ),
            child: Text(
              'Sync',
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                color: context.appColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}