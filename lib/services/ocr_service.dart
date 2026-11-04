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
    return _toRows(result);
  }

  /// Rebuilds table rows: groups text that sits at the same height on the
  /// photo into one line, ordered left to right.
  String _toRows(RecognizedText result) {
    final lines = <TextLine>[];
    for (final block in result.blocks) {
      lines.addAll(block.lines);
    }
    if (lines.isEmpty) return result.text;

    lines.sort(
      (a, b) => a.boundingBox.center.dy.compareTo(b.boundingBox.center.dy),
    );

    final heights = lines.map((l) => l.boundingBox.height).toList()..sort();
    final tolerance = heights[heights.length ~/ 2] * 0.6;

    final rows = <List<TextLine>>[];
    for (final line in lines) {
      if (rows.isNotEmpty &&
          (line.boundingBox.center.dy - rows.last.last.boundingBox.center.dy)
                  .abs() <=
              tolerance) {
        rows.last.add(line);
      } else {
        rows.add([line]);
      }
    }

    return rows
        .map((row) {
          row.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
          return row.map((l) => l.text).join(' ');
        })
        .join('\n');
  }

  void dispose() {
    _recognizer?.close();
    _recognizer = null;
  }
}
