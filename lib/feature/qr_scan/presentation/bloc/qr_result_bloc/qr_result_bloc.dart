import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'qr_result_event.dart';
part 'qr_result_state.dart';

class QrResultBloc extends Bloc<QrResultEvent, QrResultState> {
  QrResultBloc()
      : super(const QrResultInitial()) {
    on<OnResultCommentChanged>(_onCommentChanged);
  }

  void _onCommentChanged(
      final OnResultCommentChanged event,
      final Emitter<QrResultState> emit,
      ) {
    emit(state.copyWith(comment: event.comment));
  }
}
