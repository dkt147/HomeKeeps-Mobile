import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:home_keeps/resources/local_storage_keys.dart';
import 'package:home_keeps/utils/utils.dart';

class LocalStorage {
  static final getStorage = GetStorage();

  static Future init() async {
    await GetStorage.init();
    log("GetStorage initialized");
  }

  static Future<void> saveJson({required String key, required value}) {
    var res = getStorage.write(key, value);
    log("Saved key: $key with value: $value");
    return res;
  }

  static dynamic readJson({required String key}) {
    var res = getStorage.read(key);
    log("Read key: $key, value: $res");
    return res;
  }

  static Future<void> deleteJson({required String key}) {
    var res = getStorage.remove(key);
    log("Deleted key: $key");
    return res;
  }

  static void saveAccessToken(String token) {
    getStorage.write(LocalStorageKeys.accessToken, token);
    log("Access token saved: $token");
  }

  static dynamic getAccessToken() {
    var token = getStorage.read(LocalStorageKeys.accessToken) ?? "";
    log("Access token retrieved: $token");
    return token;
  }

  static void deleteAccessToken() {
    getStorage.remove(LocalStorageKeys.authToken);
    log("Access token deleted");
  }

  static void saveResetToken(String token) {
    getStorage.write(LocalStorageKeys.resetToken, token);
    log("Reset token saved: $token");
  }

  static String getResetToken() {
    var token = getStorage.read(LocalStorageKeys.resetToken) ?? "";
    log("Reset token retrieved: $token");
    return token;
  }

  static void deleteResetToken() {
    getStorage.remove(LocalStorageKeys.resetToken);
    log("Reset token deleted");
  }

  static void clearAlldata() {
    getStorage.erase();
    log("All data cleared from storage");
  }

  static void clearCredentials() {
    getStorage.remove(LocalStorageKeys.authToken);
    // getStorage.remove(LocalStorageKeys.password);
    // getStorage.remove(lsk.email);
    // getStorage.remove(lsk.remembermebool);
    Utils.logSuccess("Credentials cleared");
  }

  static void writeIfNull(String key, bool value) {
    getStorage.writeIfNull(key, value);
    log("Write if null key: $key with value: $value");
  }

  // ---------- Onboarding ----------
  static bool hasSeenOnboarding() {
    var seen =
        getStorage.read(LocalStorageKeys.hasCompletedFeatureTour) ?? false;
    log("Has seen onboarding: $seen");
    return seen;
  }

  static Future<void> setOnboardingSeen() {
    var res = getStorage.write(LocalStorageKeys.hasCompletedFeatureTour, true);
    log("Onboarding marked as seen");
    return res;
  }

  // ---------- Auto-login ----------
  static bool isLoggedIn() {
    final token = getAccessToken();
    return token != null && token.toString().isNotEmpty;
  }

  static Future<bool> saveJsonWithStatus({
    required String key,
    required dynamic value,
  }) async {
    try {
      await saveJson(key: key, value: value);
      return true;
    } catch (e) {
      log('Error saving $key: $e');
      return false;
    }
  }

  static String? readAppTheme() {
    final val = readJson(key: LocalStorageKeys.appTheme);
    if (val == null) return null;
    // support legacy boolean-like strings / values if any
    final low = val.toLowerCase();
    if (low == 'true' || low == '1') return 'dark';
    if (low == 'false' || low == '0') return 'light';
    if (low == 'dark' || low == 'light') return low;
    return null;
  }

  static Future<bool> saveAppTheme(String theme) {
    return saveJsonWithStatus(key: LocalStorageKeys.appTheme, value: theme);
  }
}
