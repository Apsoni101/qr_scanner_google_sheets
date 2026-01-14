part of 'home_screen_bloc.dart';

@immutable
sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object?> get props => [];
}

class OnHomeLoadInitial extends HomeScreenEvent {
  const OnHomeLoadInitial();
}

class OnHomeSyncPendingScans extends HomeScreenEvent {
  const OnHomeSyncPendingScans();
}

class OnHomeRefreshSheets extends HomeScreenEvent {
  const OnHomeRefreshSheets();
}

class OnHomeNetworkStatusChanged extends HomeScreenEvent {
  final bool isConnected;

  const OnHomeNetworkStatusChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}
