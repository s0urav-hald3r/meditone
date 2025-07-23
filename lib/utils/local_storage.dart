import 'package:get_storage/get_storage.dart';
import 'package:meditone/utils/app_constant.dart';

class LocalStorage {
  static final GetStorage _storage = GetStorage();

  // Initialize storage
  static Future<void> init() async {
    await GetStorage.init();
  }

  // Save premium status
  static Future<void> setPremiumStatus(bool isPremium) async {
    await _storage.write(RevenueCatConfig.isPremiumUser, isPremium);
  }

  // Get premium status
  static bool getPremiumStatus() {
    return _storage.read(RevenueCatConfig.isPremiumUser) ?? false;
  }

  // Clear premium status
  static Future<void> clearPremiumStatus() async {
    await _storage.remove(RevenueCatConfig.isPremiumUser);
  }

  // Save selected music ID
  static Future<void> setSelectedMusicId(String musicId) async {
    await _storage.write(RevenueCatConfig.selectedMusicId, musicId);
  }

  // Get selected music ID
  static String? getSelectedMusicId() {
    return _storage.read(RevenueCatConfig.selectedMusicId);
  }

  // Save selected animation ID
  static Future<void> setSelectedAnimationId(String animationId) async {
    await _storage.write(RevenueCatConfig.selectedAnimationId, animationId);
  }

  // Get selected animation ID
  static String? getSelectedAnimationId() {
    return _storage.read(RevenueCatConfig.selectedAnimationId);
  }

  // Save any data with key
  static Future<void> saveData(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Get data with key
  static T? getData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Remove data with key
  static Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _storage.erase();
  }
}
