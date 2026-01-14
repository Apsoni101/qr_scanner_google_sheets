import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';

class QrScanModel extends QrScanEntity {
  const QrScanModel({
    required super.qrData,
    required super.comment,
    required super.timestamp,
    super.deviceId,
    super.userId,
  });

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
      qrData: json['qrData'] ?? '',
      comment: json['comment'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      deviceId: json['deviceId'],
      userId: json['userId'],
    );
  }

  /// Convert from Google Sheets row format
  factory QrScanModel.fromSheetRow(final List<dynamic> row) {
    return QrScanModel(
      timestamp: row.isNotEmpty && row[0] != null
          ? DateTime.parse(row[0].toString())
          : DateTime.now(),
      qrData: row.length > 1 && row[1] != null ? row[1].toString() : '',
      comment: row.length > 2 && row[2] != null ? row[2].toString() : '',
      deviceId: row.length > 3 && row[3] != null ? row[3].toString() : null,
      userId: row.length > 4 && row[4] != null ? row[4].toString() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'qrData': qrData,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
      'deviceId': deviceId,
      'userId': userId,
    };
  }

  QrScanEntity toEntity() {
    return QrScanEntity(
      qrData: qrData,
      comment: comment,
      timestamp: timestamp,
      deviceId: deviceId,
      userId: userId,
    );
  }

  /// Convert to Google Sheets row format
  List<dynamic> toSheetRow() {
    return <dynamic>[
      timestamp.toIso8601String(),
      qrData,
      comment,
      deviceId ?? '',
      userId ?? '',
    ];
  }

  @override
  QrScanModel copyWith({
    final String? qrData,
    final String? comment,
    final DateTime? timestamp,
    final String? deviceId,
    final String? userId,
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
