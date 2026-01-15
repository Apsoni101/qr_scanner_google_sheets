import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';

part 'qr_scan_model.g.dart';

@HiveType(typeId: 1)
class QrScanModel extends QrScanEntity {
  const QrScanModel({
    @HiveField(0) required super.qrData,
    @HiveField(1) required super.comment,
    @HiveField(2) required super.timestamp,
    @HiveField(3) super.deviceId,
    @HiveField(4) super.userId,
  });

  // ---------- FACTORIES ----------

  factory QrScanModel.fromEntity(final QrScanEntity entity) {
    return QrScanModel(
      qrData: entity.qrData,
      comment: entity.comment,
      timestamp: entity.timestamp,
      deviceId: entity.deviceId,
      userId: entity.userId,
    );
  }

  factory QrScanModel.fromJson(final Map<String, dynamic> json) {
    return QrScanModel(
      qrData: json['qrData']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      deviceId: json['deviceId']?.toString(),
      userId: json['userId']?.toString(),
    );
  }

  /// Google Sheets → Model
  factory QrScanModel.fromSheetRow(final List<dynamic> row) {
    return QrScanModel(
      timestamp: row.isNotEmpty && row[0] != null
          ? DateTime.parse(row[0].toString())
          : DateTime.now(),
      qrData: row.length > 1 ? row[1]?.toString() ?? '' : '',
      comment: row.length > 2 ? row[2]?.toString() ?? '' : '',
      deviceId: row.length > 3 ? row[3]?.toString() : null,
      userId: row.length > 4 ? row[4]?.toString() : null,
    );
  }

  // ---------- MAPPERS ----------

  Map<String, dynamic> toJson() => {
    'qrData': qrData,
    'comment': comment,
    'timestamp': timestamp.toIso8601String(),
    'deviceId': deviceId,
    'userId': userId,
  };

  Map<String, dynamic> toHiveMap() => {
    'qrData': qrData,
    'comment': comment,
    'timestamp': timestamp.toIso8601String(),
    'deviceId': deviceId,
    'userId': userId,
  };

  List<dynamic> toSheetRow() => <dynamic>[
    timestamp.toIso8601String(),
    qrData,
    comment,
    deviceId ?? '',
    userId ?? '',
  ];



  QrScanEntity toEntity() {
    return QrScanEntity(
      qrData: qrData,
      comment: comment,
      timestamp: timestamp,
      deviceId: deviceId,
      userId: userId,
    );
  }

  // ---------- COPY ----------

  @override
  QrScanModel copyWith({
    String? qrData,
    String? comment,
    DateTime? timestamp,
    String? deviceId,
    String? userId,
  }) {
    return QrScanModel(
      qrData: qrData ?? this.qrData,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
    );
  }
}
