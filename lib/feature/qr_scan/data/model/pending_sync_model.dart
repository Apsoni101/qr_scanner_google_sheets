import 'package:hive/hive.dart';
import 'package:qr_scanner_practice/feature/qr_scan/data/model/qr_scan_model.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/pending_sync_entity.dart';

part 'pending_sync_model.g.dart';

@HiveType(typeId: 3)
class PendingSyncModel extends HiveObject {
  PendingSyncModel({
    required this.scan,
    required this.sheetId,
    required this.sheetTitle,
  });

  @HiveField(0)
  final QrScanModel scan;

  @HiveField(1)
  final String sheetId;

  @HiveField(2)
  final String sheetTitle;

  factory PendingSyncModel.fromEntity(PendingSyncEntity entity) {
    return PendingSyncModel(
      scan: QrScanModel.fromEntity(entity.scan),
      sheetId: entity.sheetId,
      sheetTitle: entity.sheetTitle,
    );
  }

  PendingSyncEntity toEntity() {
    return PendingSyncEntity(
      scan: scan.toEntity(),
      sheetId: sheetId,
      sheetTitle: sheetTitle,
    );
  }

  factory PendingSyncModel.fromJson(Map<String, dynamic> json) {
    return PendingSyncModel(
      scan: QrScanModel.fromJson(json['scan'] ?? {}),
      sheetId: json['sheetId'] ?? '',
      sheetTitle: json['sheetTitle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scan': scan.toJson(),
      'sheetId': sheetId,
      'sheetTitle': sheetTitle,
    };
  }

  PendingSyncModel copyWith({
    QrScanModel? scan,
    String? sheetId,
    String? sheetTitle,
  }) {
    return PendingSyncModel(
      scan: scan ?? this.scan,
      sheetId: sheetId ?? this.sheetId,
      sheetTitle: sheetTitle ?? this.sheetTitle,
    );
  }
}