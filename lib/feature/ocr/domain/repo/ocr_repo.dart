import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/feature/ocr/domain/entity/ocr_result_entity.dart';

abstract class OcrRepository {
  Future<Either<Failure, OcrResultEntity>> recognizeTextFromGallery();

  Future<Either<Failure, OcrResultEntity>> recognizeTextFromCamera();
}
