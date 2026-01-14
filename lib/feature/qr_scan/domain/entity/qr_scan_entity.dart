import 'package:equatable/equatable.dart';

class QrScanEntity extends Equatable {
  const QrScanEntity({
    required this.qrData,
    required this.comment,
    required this.timestamp,
    this.deviceId,
    this.userId,
  });

  final String qrData;
  final String comment;
  final DateTime timestamp;
  final String? deviceId;
  final String? userId;

  QrScanEntity copyWith({
    final String? qrData,
    final String? comment,
    final DateTime? timestamp,
    final String? deviceId,
    final String? userId,
  }) {
    return QrScanEntity(
      qrData: qrData ?? this.qrData,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    qrData,
    comment,
    timestamp,
    deviceId,
    userId,
  ];
}
