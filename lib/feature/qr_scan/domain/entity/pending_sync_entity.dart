import 'package:equatable/equatable.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';

class PendingSyncEntity extends Equatable {
  const PendingSyncEntity({
    required this.scan,
    required this.sheetId,
    required this.sheetTitle,
  });

  final QrScanEntity scan;
  final String sheetId;
  final String sheetTitle;

  PendingSyncEntity copyWith({
    final QrScanEntity? scan,
    final String? sheetId,
    final String? sheetTitle,
  }) {
    return PendingSyncEntity(
      scan: scan ?? this.scan,
      sheetId: sheetId ?? this.sheetId,
      sheetTitle: sheetTitle ?? this.sheetTitle,
    );
  }

  @override
  List<Object?> get props => <Object?>[scan, sheetId, sheetTitle];
}
