part of 'home_screen_bloc.dart';

class HomeScreenState extends Equatable {
  final bool isLoading;
  final bool isSyncing;
  final bool isOnline;
  final int pendingSyncCount;
  final String? error;
  final String? syncError;
  final bool showSyncSuccess;

  const HomeScreenState({
    this.isLoading = false,
    this.isSyncing = false,
    this.isOnline = true,
    this.pendingSyncCount = 0,
    this.error,
    this.syncError,
    this.showSyncSuccess = false,
  });

  HomeScreenState copyWith({
    bool? isLoading,
    bool? isSyncing,
    bool? isOnline,
    int? pendingSyncCount,
    String? error,
    String? syncError,
    bool? showSyncSuccess,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      isOnline: isOnline ?? this.isOnline,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      error: error,
      syncError: syncError,
      showSyncSuccess: showSyncSuccess ?? this.showSyncSuccess,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSyncing,
    isOnline,
    pendingSyncCount,
    error,
    syncError,
    showSyncSuccess,
  ];
}

class HomeScreenInitial extends HomeScreenState {
  const HomeScreenInitial();
}
