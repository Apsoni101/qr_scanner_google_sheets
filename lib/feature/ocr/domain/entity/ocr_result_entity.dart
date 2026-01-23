import 'dart:io';
import 'package:equatable/equatable.dart';

class OcrResultEntity extends Equatable {
  const OcrResultEntity({
    required this.recognizedText,
    required this.imageFile,
  });

  final String recognizedText;
  final File imageFile;

  OcrResultEntity copyWith({
    final String? recognizedText,
    final File? imageFile,
  }) {
    return OcrResultEntity(
      recognizedText: recognizedText ?? this.recognizedText,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  @override
  List<Object?> get props => <Object?>[recognizedText, imageFile];
}
