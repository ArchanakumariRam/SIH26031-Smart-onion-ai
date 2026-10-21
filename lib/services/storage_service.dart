import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String getLanguage() {
    return _prefs?.getString(AppConstants.keyLanguage) ?? 'en';
  }

  Future<void> setLanguage(String code) async {
    await _prefs?.setString(AppConstants.keyLanguage, code);
  }

  String getDistrict() {
    return _prefs?.getString(AppConstants.keyDistrict) ?? 'नाशिक (Nashik)';
  }

  Future<void> setDistrict(String district) async {
    await _prefs?.setString(AppConstants.keyDistrict, district);
  }

  String getApiKey() {
    return _prefs?.getString(AppConstants.keyApiKey) ?? '';
  }

  Future<void> setApiKey(String key) async {
    await _prefs?.setString(AppConstants.keyApiKey, key);
  }

  bool isOnboarded() {
    return _prefs?.getBool('is_onboarded') ?? false;
  }

  Future<void> setOnboarded(bool val) async {
    await _prefs?.setBool('is_onboarded', val);
  }

  // Persist scan history
  List<String> getRawScans() {
    return _prefs?.getStringList('user_scan_history') ?? [];
  }

  Future<void> saveRawScans(List<String> rawJsonList) async {
    await _prefs?.setStringList('user_scan_history', rawJsonList);
  }

  // Persist price alerts
  List<String> getRawPriceAlerts() {
    return _prefs?.getStringList('user_price_alerts') ?? [];
  }

  Future<void> saveRawPriceAlerts(List<String> alertsJsonList) async {
    await _prefs?.setStringList('user_price_alerts', alertsJsonList);
  }
}
