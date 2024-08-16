class GoogleSheetsState {
  final bool isLoading;
  final String? error;
  final bool isSheet2;
  final bool isSuccess;
  final bool isClearingSheets;
  final String? successMessage;
  final bool isUploading;



  GoogleSheetsState({
    this.isLoading = false,
    this.error,
    this.isSheet2 = false,
    this.isSuccess = false,
    this.isClearingSheets = false,
    this.successMessage,
    this.isUploading = false,

  });

  GoogleSheetsState copyWith({
    bool? isLoading,
    String? error,
    bool? isSheet2,
    bool? isSuccess,
    bool? isClearingSheets,
    String? successMessage,
    bool? isUploading,

  }) {
    return GoogleSheetsState(
      isUploading: isUploading ?? this.isUploading,

      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSheet2: isSheet2 ?? this.isSheet2,
      isSuccess: isSuccess ?? this.isSuccess,
      isClearingSheets: isClearingSheets ?? this.isClearingSheets,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}