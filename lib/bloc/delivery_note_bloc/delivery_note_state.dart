class DeliveryNoteState {
final bool isLoading;
final bool isSuccess;
final String? error;
final List<Map<String, String>> companies;
final Map<String, String>? selectedCompany;
final String? irsaliyeNo;

DeliveryNoteState({
  this.isLoading = false,
  this.isSuccess = false,
  this.error,
  this.companies = const [],
  this.selectedCompany,
  this.irsaliyeNo,
});

DeliveryNoteState copyWith({
  bool? isLoading,
  bool? isSuccess,
  String? error,
  List<Map<String, String>>? companies,
  Map<String, String>? selectedCompany,
  String? irsaliyeNo,
}) {
  return DeliveryNoteState(
    isLoading: isLoading ?? this.isLoading,
    isSuccess: isSuccess ?? this.isSuccess,
    error: error ?? this.error,
    companies: companies ?? this.companies,
    selectedCompany: selectedCompany ?? this.selectedCompany,
    irsaliyeNo: irsaliyeNo ?? this.irsaliyeNo,
  );
}
}
