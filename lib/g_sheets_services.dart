import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:gsheets/gsheets.dart';

import 'package:googleapis/sheets/v4.dart' as sheets;

class GoogleSheetsService {
 
  static const _scopes = [SheetsApi.spreadsheetsScope];

  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheetDeneme;
  static Worksheet? _currentWorksheet;
  static Worksheet? _worksheet7;
  static Worksheet? _worksheetCompanies;

  static Future<void> init() async {
    try {
      final ss = await _gsheets.spreadsheet(_spreadsheetId);
      _worksheetDeneme = ss.worksheetByTitle('Main');
      _worksheet7 = ss.worksheetByTitle('Defects');
      _currentWorksheet = _worksheetDeneme;
      _worksheetCompanies = ss.worksheetByTitle('Companies');

      print('Sheets initialized successfully');
    } catch (e) {
      print('Error initializing sheets: $e');
    }
  }

  static Future<void> insertIrsaliyeData({
    required String tarih,
    required String firma,
    required String irsaliyeNo,
    required String irsaliyeKg,
    required String saat,
    required String aracPlakasi,
  }) async {
    if (_currentWorksheet == null) {
      print('No worksheet selected');
      return;
    }

    try {
      await Future.wait([
        _currentWorksheet!.values.insertValue(tarih, column: 3, row: 4),
        _currentWorksheet!.values.insertValue(firma, column: 3, row: 5),
        _currentWorksheet!.values.insertValue(irsaliyeNo, column: 3, row: 6),
        _currentWorksheet!.values.insertValue(irsaliyeKg, column: 3, row: 7),
        _currentWorksheet!.values.insertValue(saat, column: 16, row: 4),
        _currentWorksheet!.values.insertValue(aracPlakasi, column: 16, row: 6),
      ]);
      print('Irsaliye data inserted successfully');
    } catch (e) {
      print('Error inserting irsaliye data: $e');
      throw e;
    }
  }
  static Future<List<Map<String, String>>> getCompanies() async {
    if (_worksheetCompanies == null) {
      print('Companies worksheet is not initialized');
      return [];
    }

    try {
      final values = await _worksheetCompanies!.values.allRows();
      return values.skip(1).map((row) {
        return {
          'name': row[0],
          'prefix': row[1],
        };
      }).toList();
    } catch (e) {
      print('Error fetching companies: $e');
      return [];
    }
  }

  static Future<String> getNextIrsaliyeNo(String prefix) async {
    if (_currentWorksheet == null) {
      print('No worksheet selected');
      return '';
    }

    try {
      final lastIrsaliyeNo = await _currentWorksheet!.values.value(column: 3, row: 6);
      if (lastIrsaliyeNo != null && lastIrsaliyeNo.startsWith(prefix)) {
        final numberPart = int.parse(lastIrsaliyeNo.substring(prefix.length));
        return '$prefix${(numberPart + 1).toString().padLeft(8, '0')}';
      }
      return '${prefix}00000001';
    } catch (e) {
      print('Error getting next irsaliye number: $e');
      return '';
    }
  }
  static Future<void> insertData(
      Map<String, String> data, int selectedNumber) async {
    if (_currentWorksheet == null) {
      print('No worksheet selected');
      return;
    }

    int rowToInsert = 8 + selectedNumber;

    try {
      await Future.wait([
        _currentWorksheet!.values
            .insertValue(data['ETIKET'] ?? '', column: 2, row: rowToInsert),
        _currentWorksheet!.values
            .insertValue(data['EBAT'] ?? '', column: 6, row: rowToInsert),
        _currentWorksheet!.values
            .insertValue(data['KALITE'] ?? '', column: 9, row: rowToInsert),
        _currentWorksheet!.values
            .insertValue(data['DOKUM'] ?? '', column: 15, row: rowToInsert),
        _currentWorksheet!.values
            .insertValue(data['AGIRLIK'] ?? '', column: 16, row: rowToInsert),
        _currentWorksheet!.values
            .insertValue(data['PAKET'] ?? '', column: 13, row: rowToInsert),
      ]);
      print('Data inserted successfully to row $rowToInsert');
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

  static Future<void> insertProductDefect(
      String defectDescription, int selectedNumber) async {
    if (_currentWorksheet == null) {
      print('No worksheet selected');
      return;
    }

    int rowToInsert = 8 + selectedNumber;

    try {
      await _currentWorksheet!.values
          .insertValue(defectDescription, column: 17, row: rowToInsert);
      print('Product defect inserted successfully to cell Q$rowToInsert');
    } catch (e) {
      print('Error inserting product defect: $e');
      throw e;
    }
  }

  static Future<void> clearRange() async {
    try {
      final spreadsheetId = _spreadsheetId;
      final credentials = ServiceAccountCredentials.fromJson(_credentials);
      final client = await clientViaServiceAccount(
          credentials, [sheets.SheetsApi.spreadsheetsScope]);
      final sheetsApi = sheets.SheetsApi(client);

      final spreadsheet = await sheetsApi.spreadsheets.get(spreadsheetId);
      final requests = spreadsheet.sheets!
          .map((sheet) {
            return [
              sheets.Request(
                updateCells: sheets.UpdateCellsRequest(
                  range: sheets.GridRange(
                    sheetId: sheet.properties!.sheetId,
                    startRowIndex: 8, // 8. satır
                    endRowIndex: 29,  // 33. satır (33 dahil değil)
                    startColumnIndex: 1, // 1. sütun (B sütunu)
                    endColumnIndex: 17, // 17. sütun (Q sütunu, 17 dahil değil)
                  ),
                  fields: 'userEnteredValue',
                ),
              ),
              sheets.Request(
                updateCells: sheets.UpdateCellsRequest(
                  range: sheets.GridRange(
                    sheetId: sheet.properties!.sheetId,
                    startRowIndex: 3,
                    endRowIndex: 4,
                    startColumnIndex: 2,
                    endColumnIndex: 9,
                  ),
                  fields: 'userEnteredValue',
                ),
              ),
              sheets.Request(
                updateCells: sheets.UpdateCellsRequest(
                  range: sheets.GridRange(
                    sheetId: sheet.properties!.sheetId,
                    startRowIndex: 4,
                    endRowIndex: 5,
                    startColumnIndex: 2,
                    endColumnIndex: 9,
                  ),
                  fields: 'userEnteredValue',
                ),
              ),
              sheets.Request(
                updateCells: sheets.UpdateCellsRequest(
                  range: sheets.GridRange(
                    sheetId: sheet.properties!.sheetId,
                    startRowIndex: 5,
                    endRowIndex: 6,
                    startColumnIndex: 2,
                    endColumnIndex: 9,
                  ),
                  fields: 'userEnteredValue',
                ),
              ),
              sheets.Request(
                updateCells: sheets.UpdateCellsRequest(
                  range: sheets.GridRange(
                    sheetId: sheet.properties!.sheetId,
                    startRowIndex: 6,
                    endRowIndex: 7,
                    startColumnIndex: 2,
                    endColumnIndex: 9,
                  ),
                  fields: 'userEnteredValue',
                ),
              ),
              sheets.Request(
                updateCells: sheets.UpdateCellsRequest(
                  range: sheets.GridRange(
                    sheetId: sheet.properties!.sheetId,
                    startRowIndex: 3,
                    endRowIndex: 4,
                    startColumnIndex: 15,
                    endColumnIndex: 17,
                  ),
                  fields: 'userEnteredValue',
                ),
              ),
              sheets.Request(
                updateCells: sheets.UpdateCellsRequest(
                  range: sheets.GridRange(
                    sheetId: sheet.properties!.sheetId,
                    startRowIndex: 5,
                    endRowIndex: 6,
                    startColumnIndex: 15,
                    endColumnIndex: 17,
                  ),
                  fields: 'userEnteredValue',
                ),
              ),
            ];
          })
          .expand((element) => element)
          .toList();

      final batchUpdateRequest =
          sheets.BatchUpdateSpreadsheetRequest(requests: requests);
      await sheetsApi.spreadsheets
          .batchUpdate(batchUpdateRequest, spreadsheetId);

      print('All specified ranges in all sheets cleared successfully');
    } catch (e) {
      print('Error clearing sheets: $e');
      throw e;
    }
  }

  static Future<List<String>> getDropdownData() async {
    // Eğer _worksheet7 null ise, hata mesajı yazdır ve boş bir liste döndür
    if (_worksheet7 == null) {
      print('Sheet7 is not initialized');
      return [];
    }

    try {
      // A sütunundaki tüm verileri çek. fromRow: 1 parametresi 1. satırdan itibaren okumaya başlar.
      final values = await _worksheet7!.values.column(1, fromRow: 1);

      // Boş olmayan değerleri filtrele ve string'e çevir, ardından liste olarak döndür
      return values
          .where((value) => value != null && value.toString().trim().isNotEmpty)
          .map((e) => e.toString().trim())
          .toList();
    } catch (e) {
      // Hata oluşursa hata mesajını yazdır ve boş bir liste döndür
      print('Error fetching dropdown data from Sheet7: $e');
      return [];
    }
  }
}
