class ImageProcessingState {
  final String recognizedText;
  final Map<String, String> extractedData;
  final bool isLoading;
  final String? error;
  final bool isDataRecognized;

  ImageProcessingState({
    this.recognizedText = '',
    this.extractedData = const {
      'EBAT': '',
      'KALITE': '',
      'DOKUM': '',
      'AGIRLIK': '',
      'PAKET': '',
    },
    this.isLoading = false,
    this.error,
    this.isDataRecognized = false,
  });

  ImageProcessingState copyWith({
    String? recognizedText,
    Map<String, String>? extractedData,
    bool? isLoading,
    String? error,
    bool? isDataRecognized,
  }) {
    return ImageProcessingState(
      recognizedText: recognizedText ?? this.recognizedText,
      extractedData: extractedData ?? this.extractedData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isDataRecognized: isDataRecognized ?? this.isDataRecognized,
    );
  }
}