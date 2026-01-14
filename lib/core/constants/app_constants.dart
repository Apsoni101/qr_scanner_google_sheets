class AppConstants {
  // Sheets API URLs
  static const String sheetsBaseUrl = 'https://sheets.googleapis.com/v4/spreadsheets';

  // Drive API URLs
  static const String driveBaseUrl = 'https://www.googleapis.com/drive/v3/files';

  // App identification label
  static const String appCreatedLabel = 'qr-scanner-app';

  // Sheet headers
  static const String sheetName = 'Scans';
  static const String headerTimestamp = 'Timestamp';
  static const String headerQrData = 'QR Data';
  static const String headerComment = 'Comment';
  static const String headerDeviceId = 'Device ID';
  static const String headerUserId = 'User ID';

  // Query parameters
  static const String sheetMimeType = 'application/vnd.google-apps.spreadsheet';
  static const String sheetFields = 'files(id,name,createdTime,modifiedTime,properties,description)';
  static const int pageSize = 100;
  static const String orderBy = 'modifiedTime%20desc';

  // Range constants
  static const String appendRange = 'A2:append';
  static const String readRange = 'A2:Z1000';
  static const String clearRangeSuffix = ':clear';
}