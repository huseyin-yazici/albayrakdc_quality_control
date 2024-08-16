import 'package:flutter_bloc/flutter_bloc.dart';

import '../../g_sheets_services.dart';
import '../product_defect_bloc/product_defect_state.dart';
import 'google_sheets_event.dart';
import 'google_sheets_state.dart';

class GoogleSheetsBloc extends Bloc<GoogleSheetsEvent, GoogleSheetsState> {
  GoogleSheetsBloc() : super(GoogleSheetsState()) {
    on<UploadToGoogleSheets>(_onUploadToGoogleSheets);

    on<ClearGoogleSheetsRange>(_onClearGoogleSheetsRange);
    on<UploadCompleted>(_onUploadCompleted);
    on<UploadProductDefect>(_onUploadProductDefect);

  }

  void _onUploadCompleted(
      UploadCompleted event, Emitter<GoogleSheetsState> emit) {
    // Bu metod boş kalabilir, sadece event'in işlendiğini göstermek için
  }

  Future<void> _onUploadToGoogleSheets(
      UploadToGoogleSheets event,
      Emitter<GoogleSheetsState> emit,
      ) async {
    if (state.isUploading) return; // Eğer yükleme zaten devam ediyorsa, yeni bir yükleme başlatma

    emit(state.copyWith(isLoading: true, isUploading: true, error: null, isSuccess: false));

    try {
      await GoogleSheetsService.insertData(event.data, event.selectedNumber);

      // Ürün hatası kontrolü ve yükleme
      if (event.selectedDefect != null && event.selectedDefect != ProductDefectLoaded.defaultDefect) {
        await GoogleSheetsService.insertProductDefect(event.selectedDefect!, event.selectedNumber);
      }

      emit(state.copyWith(
        isLoading: false,
        isUploading: false,
        error: null,
        isSuccess: true,
        successMessage: 'Veri başarıyla yüklendi!',
      ));
      add(UploadCompleted());
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isUploading: false,
        error: 'Veri yüklenirken bir hata oluştu: $e',
        isSuccess: false,
      ));
    }
  }



  Future<void> _onUploadProductDefect(
      UploadProductDefect event,
      Emitter<GoogleSheetsState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));
    try {
      await GoogleSheetsService.insertProductDefect(
        event.defectDescription,
        event.selectedNumber,
      );
      emit(state.copyWith(
        isLoading: false,
        error: null,
        isSuccess: true,
        successMessage: 'Ürün hatası başarıyla kaydedildi.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ürün hatası kaydedilirken bir hata oluştu: $e',
        isSuccess: false,
      ));
    }
  }
  Future<void> _onClearGoogleSheetsRange(
      ClearGoogleSheetsRange event, Emitter<GoogleSheetsState> emit) async {
    emit(state.copyWith(isClearingSheets: true, error: null));

    try {
      await GoogleSheetsService.clearRange();
      emit(state.copyWith(
        isClearingSheets: false,
        error: null,
        isSuccess: true,
        successMessage: 'Başarıyla temizlendi',
      ));
    } catch (e) {
      emit(state.copyWith(
        isClearingSheets: false,
        error: 'Google Sheets temizlenirken bir hata oluştu: $e',
        isSuccess: false,
      ));
    }
  }
}
