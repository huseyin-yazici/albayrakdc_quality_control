import 'package:flutter_bloc/flutter_bloc.dart';
import '../../g_sheets_services.dart';
import 'product_defect_event.dart';
import 'product_defect_state.dart';

class ProductDefectBloc extends Bloc<ProductDefectEvent, ProductDefectState> {
  final GoogleSheetsService _sheetsService;

  ProductDefectBloc(this._sheetsService) : super(ProductDefectInitial()) {
    on<LoadProductDefects>(_onLoadProductDefects);
  }


  Future<void> _onLoadProductDefects(
      LoadProductDefects event,
      Emitter<ProductDefectState> emit,
      ) async {
    emit(ProductDefectLoading());
    try {
      final defects = await GoogleSheetsService.getDropdownData();
      emit(ProductDefectLoaded(defects));
    } catch (e) {
      emit(ProductDefectError(e.toString()));
    }
  }
}