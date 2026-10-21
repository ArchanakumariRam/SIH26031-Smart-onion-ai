import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/onion_scan_result.dart';
import '../models/mandi_rate.dart';
import '../models/price_alert_item.dart';
import '../services/localization_service.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';
import '../services/gemini_ai_service.dart';
import '../services/mandi_service.dart';

class AppStateProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  String _currentDistrict = 'नाशिक (Nashik)';
  bool _isScanning = false;
  OnionScanResult? _latestScanResult;
  final List<OnionScanResult> _scanHistory = [];
  final List<PriceAlertItem> _priceAlerts = [];
  bool _isSpeaking = false;

  String get currentLanguage => _currentLanguage;
  String get currentDistrict => _currentDistrict;
  bool get isScanning => _isScanning;
  OnionScanResult? get latestScanResult => _latestScanResult;
  List<OnionScanResult> get scanHistory => _scanHistory;
  List<PriceAlertItem> get priceAlerts => _priceAlerts;
  bool get isSpeaking => _isSpeaking;

  Future<void> initialize() async {
    final storage = StorageService();
    await storage.init();
    _currentLanguage = storage.getLanguage();
    _currentDistrict = storage.getDistrict();
    final savedApiKey = storage.getApiKey();
    if (savedApiKey.isNotEmpty) {
      GeminiAiService().setApiKey(savedApiKey);
    }
    await LocalizationService().loadLanguage(_currentLanguage);
    TtsService().init();

    // Load Scan History from storage
    _loadSavedScans();

    // Load Price Alerts from storage
    _loadSavedPriceAlerts();

    notifyListeners();
  }

  void _loadSavedScans() {
    final storage = StorageService();
    final rawList = storage.getRawScans();
    _scanHistory.clear();

    if (rawList.isNotEmpty) {
      for (var jsonStr in rawList) {
        try {
          final Map<String, dynamic> map = jsonDecode(jsonStr);
          _scanHistory.add(OnionScanResult.fromJson(map, imagePath: map['image_path']));
        } catch (_) {}
      }
    }

    // Starter sample records if farmer opens the app fresh
    if (_scanHistory.isEmpty) {
      _scanHistory.addAll([
        OnionScanResult(
          variety: 'Garwa (Rabi Summer)',
          varietyLocalName: 'उन्हाळ कांदा (Garwa)',
          sizeGrade: 'Medium (45-60 mm)',
          qualityGrade: 'A',
          qualityScorePercentage: 92,
          defectsDetected: ['none'],
          storageViabilityDays: 120,
          actionAdvice: 'उत्कृष्ट दर्जाचा कांदा आहे. पुढील ३ महिने चाळीत सहज टिकेल. बाजारभाव वाढीची वाट पहा.',
          estimatedPriceMin: 2450,
          estimatedPriceMax: 2750,
          timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        ),
        OnionScanResult(
          variety: 'Rangda (Late Kharif)',
          varietyLocalName: 'रांगडा कांदा (Rangda)',
          sizeGrade: 'Big (>60 mm)',
          qualityGrade: 'B',
          qualityScorePercentage: 78,
          defectsDetected: ['Thick neck (डहाळा)'],
          storageViabilityDays: 35,
          actionAdvice: 'डहाळा कांद्याचे प्रमाण आढळले आहे. जास्त दिवस साठवू नका, पुढील १५ दिवसांत विक्री करा.',
          estimatedPriceMin: 1850,
          estimatedPriceMax: 2200,
          timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 8)),
        ),
      ]);
      _persistScans();
    }
  }

  void _loadSavedPriceAlerts() {
    final storage = StorageService();
    final rawAlerts = storage.getRawPriceAlerts();
    _priceAlerts.clear();

    if (rawAlerts.isNotEmpty) {
      for (var str in rawAlerts) {
        try {
          final Map<String, dynamic> map = jsonDecode(str);
          _priceAlerts.add(PriceAlertItem.fromJson(map));
        } catch (_) {}
      }
    }

    if (_priceAlerts.isEmpty) {
      _priceAlerts.addAll([
        PriceAlertItem(
          id: '1',
          mandiName: 'Lasalgaon APMC (लासलगाव)',
          targetPrice: 2800,
          condition: 'ABOVE',
          isEnabled: true,
        ),
        PriceAlertItem(
          id: '2',
          mandiName: 'Pune Gultekdi (पुणे गुलटेकडी)',
          targetPrice: 3000,
          condition: 'ABOVE',
          isEnabled: true,
        ),
      ]);
      _persistPriceAlerts();
    }
  }

  Future<void> _persistScans() async {
    final rawList = _scanHistory.map((s) => jsonEncode(s.toJson())).toList();
    await StorageService().saveRawScans(rawList);
  }

  Future<void> _persistPriceAlerts() async {
    final rawList = _priceAlerts.map((a) => jsonEncode(a.toJson())).toList();
    await StorageService().saveRawPriceAlerts(rawList);
  }

  Future<void> changeLanguage(String langCode) async {
    _currentLanguage = langCode;
    await StorageService().setLanguage(langCode);
    await LocalizationService().loadLanguage(langCode);
    notifyListeners();
  }

  Future<void> setDistrict(String district) async {
    _currentDistrict = district;
    await StorageService().setDistrict(district);
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    await StorageService().setApiKey(key);
    GeminiAiService().setApiKey(key);
    notifyListeners();
  }

  Future<OnionScanResult?> analyzeOnionImage(String imagePath) async {
    _isScanning = true;
    notifyListeners();

    try {
      final result = await GeminiAiService().analyzeOnionImage(
        imagePath: imagePath,
        languageCode: _currentLanguage,
      );
      _latestScanResult = result;
      _scanHistory.insert(0, result);
      await _persistScans();
      _isScanning = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isScanning = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteScan(int index) async {
    if (index >= 0 && index < _scanHistory.length) {
      _scanHistory.removeAt(index);
      await _persistScans();
      notifyListeners();
    }
  }

  Future<void> clearScanHistory() async {
    _scanHistory.clear();
    await _persistScans();
    notifyListeners();
  }

  Future<void> addPriceAlert(PriceAlertItem alert) async {
    _priceAlerts.insert(0, alert);
    await _persistPriceAlerts();
    notifyListeners();
  }

  Future<void> togglePriceAlert(int index) async {
    if (index >= 0 && index < _priceAlerts.length) {
      _priceAlerts[index].isEnabled = !_priceAlerts[index].isEnabled;
      await _persistPriceAlerts();
      notifyListeners();
    }
  }

  Future<void> deletePriceAlert(int index) async {
    if (index >= 0 && index < _priceAlerts.length) {
      _priceAlerts.removeAt(index);
      await _persistPriceAlerts();
      notifyListeners();
    }
  }

  Future<void> toggleSpeak(String text) async {
    final tts = TtsService();
    if (_isSpeaking) {
      await tts.stop();
      _isSpeaking = false;
    } else {
      _isSpeaking = true;
      notifyListeners();
      await tts.speak(text, _currentLanguage);
      _isSpeaking = false;
    }
    notifyListeners();
  }

  void stopSpeak() {
    TtsService().stop();
    _isSpeaking = false;
    notifyListeners();
  }

  List<MandiRate> getMandiRates() {
    return MandiService().getLiveMandiRates(originCity: _currentDistrict);
  }
}
