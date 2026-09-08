import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _storage = GetStorage();
  static const String _languageKey = 'selected_language';

  Locale currentLocale = const Locale('en', 'US');

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  void loadSavedLanguage() {
    final savedLang = _storage.read(_languageKey);
    if (savedLang != null) {
      final parts = savedLang.toString().split('_');
      if (parts.length == 2) {
        currentLocale = Locale(parts[0], parts[1]);
        Get.updateLocale(currentLocale);
      }
    }
  }

  void changeLanguage(String languageCode, String countryCode) {
    currentLocale = Locale(languageCode, countryCode);
    Get.updateLocale(currentLocale);
    _storage.write(_languageKey, '${languageCode}_$countryCode');
    update();
  }
}
