abstract class ImageProcessingEvent {}

class RecognizeTextFromCamera extends ImageProcessingEvent {}

class RecognizeTextFromGallery extends ImageProcessingEvent {}

class PrintRecognizedText extends ImageProcessingEvent {}
class ResetImageProcessingState extends ImageProcessingEvent {}
