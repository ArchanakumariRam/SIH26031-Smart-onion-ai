import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void init() {
    _flutterTts = FlutterTts();
    _flutterTts?.setSpeechRate(0.45); // Farmer-friendly, easy to follow
    _flutterTts?.setVolume(1.0);
    _flutterTts?.setPitch(1.0);

    _flutterTts?.setCompletionHandler(() {
      _isPlaying = false;
    });

    _flutterTts?.setErrorHandler((msg) {
      _isPlaying = false;
    });
  }

  Future<void> speak(String text, String langCode) async {
    if (_flutterTts == null) init();
    try {
      await stop();
      String ttsLang = "mr-IN";
      if (langCode == "hi") {
        ttsLang = "hi-IN";
      } else if (langCode == "en") {
        ttsLang = "en-IN";
      } else if (langCode == "te") {
        ttsLang = "te-IN";
      }

      await _flutterTts?.setLanguage(ttsLang);
      _isPlaying = true;
      await _flutterTts?.speak(text);
    } catch (e) {
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    try {
      if (_flutterTts != null) {
        await _flutterTts?.stop();
      }
      _isPlaying = false;
    } catch (_) {}
  }
}
