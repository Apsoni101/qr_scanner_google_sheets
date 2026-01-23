import 'package:qr_scanner_practice/feature/ocr/domain/entity/ocr_result_entity.dart';

class OcrResultModel extends OcrResultEntity {
  const OcrResultModel({
    required super.recognizedText,
    required super.imageFile,
  });

  /// Create model from entity
  factory OcrResultModel.fromEntity(final OcrResultEntity entity) {
    return OcrResultModel(
      recognizedText: entity.recognizedText,
      imageFile: entity.imageFile,
    );
  }

  /// Convert model back to entity
  OcrResultEntity toEntity() {
    return OcrResultEntity(
      recognizedText: recognizedText,
      imageFile: imageFile,
    );
  }
}
