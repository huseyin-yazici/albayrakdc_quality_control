abstract class DataManagementEvent {}

class UpdateSelectedNumber extends DataManagementEvent {
  final int number;
  UpdateSelectedNumber(this.number);

}

class IncrementSelectedNumber extends DataManagementEvent {}

class UpdateTextFieldValue extends DataManagementEvent {
  final String field;
  final String value;

  UpdateTextFieldValue(this.field, this.value);
}
class UpdateExtractedData extends DataManagementEvent {
  final Map<String, String> extractedData;
  UpdateExtractedData(this.extractedData);
}
class ResetFields extends DataManagementEvent {}

class UpdateSelectedDefect extends DataManagementEvent {
  final String? defect;

  UpdateSelectedDefect(this.defect);
}
class ResetSelectedNumberToOne extends DataManagementEvent {}
