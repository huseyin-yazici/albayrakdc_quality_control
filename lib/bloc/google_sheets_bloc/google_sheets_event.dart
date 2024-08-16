
abstract class GoogleSheetsEvent {}
class UploadToGoogleSheets extends GoogleSheetsEvent {
  final Map<String, String> data;
  final int selectedNumber;
  final String selectedDefect;

  UploadToGoogleSheets({
    required this.data,
    required this.selectedNumber,
    required this.selectedDefect,
  });

  @override
  List<Object> get props => [data, selectedNumber, selectedDefect];
}
class SwitchToSheet2 extends GoogleSheetsEvent {}

class ClearGoogleSheetsRange extends GoogleSheetsEvent {}
class UploadCompleted extends GoogleSheetsEvent {}
class UploadProductDefect extends GoogleSheetsEvent {
  final String defectDescription;
  final int selectedNumber;

  UploadProductDefect(this.defectDescription, this.selectedNumber);
}