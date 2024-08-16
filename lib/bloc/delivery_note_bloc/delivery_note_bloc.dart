import 'package:flutter_bloc/flutter_bloc.dart';
import '../../g_sheets_services.dart';
import 'package:intl/intl.dart';
import 'delivery_note_event.dart';
import 'delivery_note_state.dart';

class DeliveryNoteBloc extends Bloc<DeliveryNoteEvent, DeliveryNoteState> {
  DeliveryNoteBloc() : super(DeliveryNoteState()) {
    on<SubmitDeliveryNote>(_onSubmitDeliveryNote);
    on<LoadCompanies>(_onLoadCompanies);
    on<SelectCompany>(_onSelectCompany);
  }

  Future<void> _onSubmitDeliveryNote(SubmitDeliveryNote event, Emitter<DeliveryNoteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await GoogleSheetsService.insertIrsaliyeData(
        tarih: DateFormat('dd.MM.yyyy').format(DateTime.now()),
        firma: event.firma,
        irsaliyeNo: event.irsaliyeNo,
        irsaliyeKg: event.irsaliyeKg,
        saat: DateFormat('HH:mm').format(DateTime.now()),
        aracPlakasi: event.aracPlakasi,
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadCompanies(LoadCompanies event, Emitter<DeliveryNoteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final companies = await GoogleSheetsService.getCompanies();
      emit(state.copyWith(isLoading: false, companies: companies));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSelectCompany(SelectCompany event, Emitter<DeliveryNoteState> emit) async {
    final selectedCompany = state.companies.firstWhere((company) => company['name'] == event.companyName);
    final nextIrsaliyeNo = await GoogleSheetsService.getNextIrsaliyeNo(selectedCompany['prefix']!);
    emit(state.copyWith(selectedCompany: selectedCompany, irsaliyeNo: nextIrsaliyeNo));
  }
}