import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text, {String lang = 'en-IN'}) async {
    await _tts.stop();
    try {
      final ok = await _tts.isLanguageAvailable(lang);
      await _tts.setLanguage(ok == true ? lang : 'en-US');
    } catch (_) {
      await _tts.setLanguage('en-US');
    }
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
