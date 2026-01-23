import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/core/services/image_picker_service.dart';
import 'package:qr_scanner_practice/core/services/ocr_service.dart';
import 'package:qr_scanner_practice/feature/ocr/data/model/ocr_result_model.dart';

abstract class OcrDataSource {
  Future<Either<Failure, OcrResultModel>> recognizeTextFromGallery();
  Future<Either<Failure, OcrResultModel>> recognizeTextFromCamera();
}

class OcrDataSourceImpl implements OcrDataSource {
  const OcrDataSourceImpl({
    required this.ocrService,
    required this.imagePickerService,
  });

  final OcrService ocrService;
  final ImagePickerService imagePickerService;

  @override
  Future<Either<Failure, OcrResultModel>> recognizeTextFromGallery() async {
    final Either<Failure, String> imagePath = await imagePickerService
        .pickImageFromGallery();

    return imagePath.fold(Left.new, (final String path) async {
      final File imageFile = File(path);

      final Either<Failure, String> textResult = await ocrService.recognizeText(
        imageFile,
      );

      return textResult.map(
        (final String text) =>
            OcrResultModel(recognizedText: text, imageFile: imageFile),
      );
    });
  }

  @override
  Future<Either<Failure, OcrResultModel>> recognizeTextFromCamera() async {
    final Either<Failure, String> imagePath = await imagePickerService
        .pickImageFromCamera();

    return imagePath.fold(Left.new, (final String path) async {
      final File imageFile = File(path);

      final Either<Failure, String> textResult = await ocrService.recognizeText(
        imageFile,
      );

      return textResult.map(
        (final String text) =>
            OcrResultModel(recognizedText: text, imageFile: imageFile),
      );
    });
  }
}
