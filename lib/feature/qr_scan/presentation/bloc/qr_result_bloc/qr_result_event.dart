part of 'qr_result_bloc.dart';

@immutable
sealed class QrResultEvent extends Equatable {
  const QrResultEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class OnResultCommentChanged extends QrResultEvent {
  const OnResultCommentChanged(this.comment);

  final String comment;

  @override
  List<Object?> get props => <Object?>[comment];
}
