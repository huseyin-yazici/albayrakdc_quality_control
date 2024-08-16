import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/wire_rod_field_controller.dart';
import '../product_defect_bloc/product_defect_state.dart';
import 'data_management_event.dart';
import 'data_management_state.dart';

class DataManagementBloc
    extends Bloc<DataManagementEvent, DataManagementState> {
  final controllers = WireRodControllers.controllers;

  DataManagementBloc() : super(DataManagementState()) {
    on<UpdateSelectedNumber>(_onUpdateSelectedNumber);
    on<IncrementSelectedNumber>(_onIncrementSelectedNumber);
    on<UpdateTextFieldValue>(_onUpdateTextFieldValue);
    on<UpdateExtractedData>(_onUpdateExtractedData);
    on<ResetFields>(_onResetFields);
    on<UpdateSelectedDefect>(_onUpdateSelectedDefect);
    on<ResetSelectedNumberToOne>(_onResetSelectedNumberToOne); // Yeni işleyici
  }

  void _onResetSelectedNumberToOne(
      ResetSelectedNumberToOne event, Emitter<DataManagementState> emit) {
    emit(state.copyWith(
      selectedNumber: 1,
      fieldValues: _getEmptyFieldValues(),
      selectedDefect:
          ProductDefectLoaded.defaultDefect, // Varsayılan değeri sıfırlayın
    ));
    _resetControllers();
  }

  void _onUpdateSelectedNumber(
      UpdateSelectedNumber event, Emitter<DataManagementState> emit) {
    emit(state.copyWith(
      selectedNumber: event.number,
      fieldValues: _getEmptyFieldValues(),
      selectedDefect: ProductDefectLoaded.defaultDefect, // Reset to default
    ));
    _resetControllers();
  }

  void _onIncrementSelectedNumber(
      IncrementSelectedNumber event, Emitter<DataManagementState> emit) {
    final newNumber = state.selectedNumber < 25 ? state.selectedNumber + 1 : 1;
    emit(state.copyWith(
      selectedNumber: newNumber,
      fieldValues: _getEmptyFieldValues(),
      selectedDefect: ProductDefectLoaded.defaultDefect, // Reset to default
    ));
    _resetControllers();
  }

  void _onUpdateSelectedDefect(
      UpdateSelectedDefect event, Emitter<DataManagementState> emit) {
    emit(state.copyWith(selectedDefect: event.defect));
  }

  void _onUpdateTextFieldValue(
      UpdateTextFieldValue event, Emitter<DataManagementState> emit) {
    controllers[event.field]?.text = event.value;
    final updatedFieldValues = Map<String, String>.from(state.fieldValues);
    updatedFieldValues[event.field] = event.value;
    emit(state.copyWith(fieldValues: updatedFieldValues));
  }

  void _onUpdateExtractedData(
      UpdateExtractedData event, Emitter<DataManagementState> emit) {
    final updatedFieldValues = Map<String, String>.from(state.fieldValues);
    updatedFieldValues.addAll(event.extractedData);
    emit(state.copyWith(fieldValues: updatedFieldValues));
  }

  void _onResetFields(ResetFields event, Emitter<DataManagementState> emit) {
    emit(state.copyWith(
      fieldValues: _getEmptyFieldValues(),
      selectedNumber: state.selectedNumber < 25 ? state.selectedNumber + 1 : 1,
      selectedDefect: null, // Alanları sıfırlarken seçilen hatayı da sıfırla
    ));
    _resetControllers();
  }

  void _resetControllers() {
    controllers.forEach((key, controller) {
      controller.text = '';
    });
  }

  Map<String, String> _getEmptyFieldValues() {
    return {
      'ETIKET': '',
      'EBAT': '',
      'KALITE': '',
      'DOKUM': '',
      'AGIRLIK': '',
      'PAKET': '',
    };
  }

  @override
  Future<void> close() {
    controllers.values.forEach((controller) => controller.dispose());
    return super.close();
  }
}
