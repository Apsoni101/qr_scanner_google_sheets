import 'package:qr_scanner_practice/feature/sheet_selection/data/model/sheet_model.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/paged_sheets_entity.dart';

class PagedSheetsModel {
  const PagedSheetsModel({
    required this.sheets,
    required this.nextPageToken,
    required this.hasMore,
  });
  factory PagedSheetsModel.fromJson(final Map<String, dynamic> json) {
    final List<dynamic> files = json['files'] ?? <dynamic>[];
    final String? pageToken = json['nextPageToken'];

    return PagedSheetsModel(
      sheets: files
          .map(
            (final dynamic f) => SheetModel.fromJson(f ?? <String, dynamic>{}),
          )
          .toList(),
      nextPageToken: pageToken,
      hasMore: pageToken != null && pageToken.isNotEmpty,
    );
  }

  factory PagedSheetsModel.fromEntity(final PagedSheetsEntity entity) {
    return PagedSheetsModel(
      sheets: entity.sheets.map(SheetModel.fromEntity).toList(),
      nextPageToken: entity.nextPageToken,
      hasMore: entity.hasMore,
    );
  }

  final List<SheetModel> sheets;
  final String? nextPageToken;
  final bool hasMore;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'files': sheets.map((final SheetModel sheet) => sheet.toJson()).toList(),
      'nextPageToken': nextPageToken,
    };
  }

  PagedSheetsEntity toEntity() {
    return PagedSheetsEntity(
      sheets: sheets.map((final SheetModel sheet) => sheet.toEntity()).toList(),
      nextPageToken: nextPageToken,
      hasMore: hasMore,
    );
  }
}
