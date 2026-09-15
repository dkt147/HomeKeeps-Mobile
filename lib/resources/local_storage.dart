import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_keeps/resources/local_storage_keys.dart';
import 'package:home_keeps/utils/utils.dart';

class LocalStorage {
  static final getStorage = GetStorage();

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future init() async {
    await GetStorage.init();
    log("GetStorage initialized");
  }

  // ---------- Non-sensitive JSON (GetStorage) ----------
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

  // ---------- Access Token (Secure) ----------
  static Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: LocalStorageKeys.accessToken, value: token);
    log("Access token saved securely");
  }

  static Future<String> getAccessToken() async {
    final token =
        await _secureStorage.read(key: LocalStorageKeys.accessToken) ?? "";
    log("Access token retrieved securely");
    return token;
  }

  static Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: LocalStorageKeys.accessToken);
    log("Access token deleted securely");
  }

  // ---------- Refresh Token (Secure) ----------
  static Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(
      key: LocalStorageKeys.refreshToken,
      value: token,
    );
    log("Refresh token saved securely");
  }

  static Future<String> getRefreshToken() async {
    final token =
        await _secureStorage.read(key: LocalStorageKeys.refreshToken) ?? "";
    log("Refresh token retrieved securely");
    return token;
  }

  static Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: LocalStorageKeys.refreshToken);
    log("Refresh token deleted securely");
  }

  // ---------- Reset Token (Secure) ----------
  static Future<void> saveResetToken(String token) async {
    await _secureStorage.write(key: LocalStorageKeys.resetToken, value: token);
    log("Reset token saved securely");
  }

  static Future<String> getResetToken() async {
    final token =
        await _secureStorage.read(key: LocalStorageKeys.resetToken) ?? "";
    log("Reset token retrieved securely");
    return token;
  }

  static Future<void> deleteResetToken() async {
    await _secureStorage.delete(key: LocalStorageKeys.resetToken);
    log("Reset token deleted securely");
  }

  // ---------- Device Token (Secure) ----------
  static Future<void> saveDeviceToken(String token) async {
    await _secureStorage.write(key: LocalStorageKeys.deviceToken, value: token);
  }

  static Future<String> getDeviceToken() async {
    return await _secureStorage.read(key: LocalStorageKeys.deviceToken) ?? "";
  }

  // ---------- User Id / Role (Secure) ----------
  static Future<void> saveUserId(String id) async {
    await _secureStorage.write(key: LocalStorageKeys.userId, value: id);
  }

  static Future<String> getUserId() async {
    return await _secureStorage.read(key: LocalStorageKeys.userId) ?? "";
  }

  static Future<void> saveRole(String role) async {
    await _secureStorage.write(key: LocalStorageKeys.role, value: role);
  }

  static Future<String> getRole() async {
    return await _secureStorage.read(key: LocalStorageKeys.role) ?? "";
  }

  // ---------- Clear ----------
  static Future<void> clearAlldata() async {
    getStorage.erase();
    await _secureStorage.deleteAll();
    log("All data cleared from storage (secure + normal)");
  }

  static Future<void> clearCredentials() async {
    await _secureStorage.delete(key: LocalStorageKeys.accessToken);
    await _secureStorage.delete(key: LocalStorageKeys.refreshToken);
    Utils.logSuccess("Credentials cleared");
  }

  static void writeIfNull(String key, bool value) {
    getStorage.writeIfNull(key, value);
    log("Write if null key: $key with value: $value");
  }

  // ---------- Onboarding (GetStorage, non-sensitive) ----------
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
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token.isNotEmpty;
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

  // ---------- App Theme (GetStorage, non-sensitive) ----------
  static String? readAppTheme() {
    final val = readJson(key: LocalStorageKeys.appTheme);
    if (val == null) return null;
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
