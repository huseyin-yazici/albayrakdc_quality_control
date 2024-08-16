import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import 'image_processing_event.dart';
import 'image_processing_state.dart';

class ImageProcessingBloc extends Bloc<ImageProcessingEvent, ImageProcessingState> {
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  final imagePicker = ImagePicker();

  ImageProcessingBloc() : super(ImageProcessingState()) {
    on<RecognizeTextFromCamera>(_onRecognizeTextFromCamera);
    on<RecognizeTextFromGallery>(_onRecognizeTextFromGallery);
    on<PrintRecognizedText>(_onPrintRecognizedText);
    on<ResetImageProcessingState>(_onResetImageProcessingState);

  }

  Future<void> _onRecognizeTextFromCamera(RecognizeTextFromCamera event, Emitter<ImageProcessingState> emit) async {
    await _recognizeText(ImageSource.camera, emit);
  }

  Future<void> _onRecognizeTextFromGallery(RecognizeTextFromGallery event, Emitter<ImageProcessingState> emit) async {
    await _recognizeText(ImageSource.gallery, emit);
  }

  Future<void> _recognizeText(ImageSource source, Emitter<ImageProcessingState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, isDataRecognized: false));

    try {
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile == null) {
        emit(state.copyWith(isLoading: false, error: 'Belge Seçilmedi'));
        return;
      }

      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final recognizedText = await textRecognizer.processImage(inputImage);

      final extractedData = _filterRecognizedText(recognizedText);
      final recognizedTextString =
      extractedData.entries.map((e) => '${e.key}: ${e.value}').join('\n');

      emit(state.copyWith(
        isLoading: false,
        recognizedText: recognizedTextString.isNotEmpty
            ? recognizedTextString
            : 'Metin bulunamadı',
        extractedData: extractedData,
        isDataRecognized: true,
      ));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          error: 'Görüntü tanınamadı. Lütfen tekrar deneyin.',
          isDataRecognized: false));
    }
  }

  Map<String, String> _filterRecognizedText(RecognizedText recognizedText) {
    final extractedData = <String, String>{
      'EBAT': '',
      'KALITE': '',
      'DOKUM': '',
      'AGIRLIK': '',
      'PAKET': '',
    };

    final List<String> allTexts = [];
    String previousText = '';

    final ebatRegex = RegExp(r'^\d{1,3}(\.\d+)?$');

    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        var text = line.text.trim();

        if (text.contains(':')) {
          text = text.split(':').last.trim();
        }

        if (text.contains('SAE')) {
          extractedData['KALITE'] = text;
          if (ebatRegex.hasMatch(previousText)) {
            extractedData['EBAT'] = previousText;
          }
        }

        allTexts.add(text);
        previousText = text;
      }
    }

    if (extractedData['EBAT']!.isEmpty) {
      var ebatText = allTexts.firstWhere(
            (text) => text.contains('Ø'),
        orElse: () => '',
      );
      if (ebatText.isNotEmpty) {
        var match = RegExp(r'Ø\s*(\d{1,3}(\.\d+)?)').firstMatch(ebatText);
        if (match != null) {
          extractedData['EBAT'] = match.group(1)!;
        } else {
          extractedData['EBAT'] = ebatText;
        }
      }
    }

    if (extractedData['EBAT']!.isEmpty) {
      for (var text in allTexts) {
        if (ebatRegex.hasMatch(text)) {
          extractedData['EBAT'] = text;
          break;
        }
      }
    }

    for (var text in allTexts) {
      if (RegExp(r'^\d{6}$').hasMatch(text)) {
        extractedData['DOKUM'] = text;
        break;
      }
    }

    if (extractedData['AGIRLIK']!.isEmpty || extractedData['PAKET']!.isEmpty) {
      for (int i = 0; i < allTexts.length; i++) {
        var text = allTexts[i];
        if (extractedData['AGIRLIK']!.isEmpty && i + 1 < allTexts.length) {
          extractedData['AGIRLIK'] = allTexts[i + 1];
        }
        if (extractedData['PAKET']!.isEmpty && RegExp(r'\d{8}').hasMatch(text)) {
          extractedData['PAKET'] = RegExp(r'\d{8}').firstMatch(text)!.group(0)!;
        }
      }
    }

    if (extractedData['AGIRLIK']!.isNotEmpty) {
      extractedData['AGIRLIK'] = extractedData['AGIRLIK']!
          .replaceAll(RegExp(r'kg', caseSensitive: false), '')
          .trim();
    }

    if (extractedData['AGIRLIK']!.isEmpty ||
        !RegExp(r'^\d{4}$').hasMatch(extractedData['AGIRLIK']!)) {
      for (var text in allTexts) {
        var cleanText = text.replaceAll(RegExp(r'kg', caseSensitive: false), '').trim();
        if (RegExp(r'^\d{4}$').hasMatch(cleanText)) {
          extractedData['AGIRLIK'] = cleanText;
          break;
        }
      }
    }

    return extractedData;
  }

  void _onPrintRecognizedText(PrintRecognizedText event, Emitter<ImageProcessingState> emit) {
    print('--- Recognized Text ---');
    state.extractedData.forEach((key, value) {
      print('$key: $value');
    });
    print('----------------------');
  }
  void _onResetImageProcessingState(ResetImageProcessingState event, Emitter<ImageProcessingState> emit) {
    emit(ImageProcessingState());
  }

  @override
  Future<void> close() {
    textRecognizer.close();
    return super.close();
  }
}