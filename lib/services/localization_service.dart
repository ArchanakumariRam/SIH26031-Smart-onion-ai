import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  String _currentLanguage = 'en'; // Default English
  Map<String, String> _localizedStrings = {};

  String get currentLanguage => _currentLanguage;

  Future<void> loadLanguage(String langCode) async {
    _currentLanguage = langCode;
    try {
      final jsonString = await rootBundle.loadString('assets/i18n/$langCode.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      // Fallback
      _localizedStrings = {};
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
