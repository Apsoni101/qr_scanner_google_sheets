part of 'ocr_bloc.dart';

@immutable
sealed class OcrState extends Equatable {
  const OcrState();

  @override
  List<Object?> get props => <Object?>[];
}

class OcrInitialState extends OcrState {
  const OcrInitialState();
}

class OcrLoadingState extends OcrState {
  const OcrLoadingState();
}

class OcrImagePickedState extends OcrState {
  const OcrImagePickedState({required this.imageFile});

  final File imageFile;

  @override
  List<Object?> get props => <Object?>[imageFile];
}

class OcrSuccessState extends OcrState {
  const OcrSuccessState({required this.result, this.imageFile});

  final String result;
  final File? imageFile;

  @override
  List<Object?> get props => <Object?>[result, imageFile];
}

class OcrErrorState extends OcrState {
  const OcrErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
