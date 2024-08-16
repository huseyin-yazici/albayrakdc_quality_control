import '../product_defect_bloc/product_defect_state.dart';

class DataManagementState {
  final int selectedNumber;
  final Map<String, String> fieldValues;
  final String selectedDefect;


  DataManagementState({
    this.selectedNumber = 1,
    this.fieldValues = const {
      'ETIKET': '',
      'EBAT': '',
      'KALITE': '',
      'DOKUM': '',
      'AGIRLIK': '',
      'PAKET': '',
    },
    this.selectedDefect = ProductDefectLoaded.defaultDefect,


  });

  DataManagementState copyWith({
    int? selectedNumber,
    Map<String, String>? fieldValues,
    String? selectedDefect,
  }) {
    return DataManagementState(
      selectedNumber: selectedNumber ?? this.selectedNumber,
      fieldValues: fieldValues ?? this.fieldValues,
      selectedDefect: selectedDefect ?? this.selectedDefect,
    );
  }
}