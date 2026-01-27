import 'package:equatable/equatable.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/sheet_entity.dart';

class PagedSheetsEntity extends Equatable {
  const PagedSheetsEntity({
    required this.sheets,
    required this.nextPageToken,
    required this.hasMore,
  });

  final List<SheetEntity> sheets;
  final String? nextPageToken;
  final bool hasMore;

  PagedSheetsEntity copyWith({
    final List<SheetEntity>? sheets,
    final String? nextPageToken,
    final bool? hasMore,
  }) {
    return PagedSheetsEntity(
      sheets: sheets ?? this.sheets,
      nextPageToken: nextPageToken ?? this.nextPageToken,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [sheets, nextPageToken, hasMore];
}
