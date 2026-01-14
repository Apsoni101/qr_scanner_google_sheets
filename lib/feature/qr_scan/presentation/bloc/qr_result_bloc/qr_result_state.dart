part of 'qr_result_bloc.dart';

@immutable
class QrResultState extends Equatable {
  const QrResultState({this.comment = ''});

  final String comment;

  QrResultState copyWith({final String? comment}) {
    return QrResultState(comment: comment ?? this.comment);
  }

  @override
  List<Object?> get props => <Object?>[comment];
}

class QrResultInitial extends QrResultState {
  const QrResultInitial();
}
