import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/feature/ocr/data/data_source/ocr_data_source.dart';
import 'package:qr_scanner_practice/feature/ocr/domain/entity/ocr_result_entity.dart';
import 'package:qr_scanner_practice/feature/ocr/domain/repo/ocr_repo.dart';

class OcrRepositoryImpl implements OcrRepository {
  const OcrRepositoryImpl({required this.ocrDataSource});

  final OcrDataSource ocrDataSource;

  @override
  Future<Either<Failure, OcrResultEntity>> recognizeTextFromGallery() async {
    return ocrDataSource.recognizeTextFromGallery();
  }

  @override
  Future<Either<Failure, OcrResultEntity>> recognizeTextFromCamera() async {
    return ocrDataSource.recognizeTextFromCamera();
  }
}
