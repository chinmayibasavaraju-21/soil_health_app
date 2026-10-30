import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrService {
  final ImagePicker _picker = ImagePicker();
  TextRecognizer? _recognizer;

  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<String?> pickAndRead({bool fromCamera = true}) async {
    if (!isSupported) {
      throw UnsupportedError('OCR only works on an Android or iOS device.');
    }

    final XFile? image = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
    );
    if (image == null) return null;

    _recognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
    final result = await _recognizer!.processImage(
      InputImage.fromFilePath(image.path),
    );
    return result.text;
  }

  void dispose() {
    _recognizer?.close();
    _recognizer = null;
  }
}
