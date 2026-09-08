import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_keeps/resources/local_storage.dart';

class ThemeService extends GetxController {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final savedTheme = LocalStorage.readAppTheme();
    if (savedTheme != null) {
      _isDarkMode = savedTheme == 'dark';
      Get.changeThemeMode(themeMode);
      _updateSystemUI();
      update();
    }
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    Get.changeThemeMode(themeMode);
    _updateSystemUI();
    await LocalStorage.saveAppTheme(_isDarkMode ? 'dark' : 'light');
    update();
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: _isDarkMode ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: _isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  // ===================== LIGHT THEME =====================
  // Colors sourced from the HomeKeep Broadsheet UI spec

  ThemeData get lightTheme => ThemeData(
    textTheme: GoogleFonts.manropeTextTheme(),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFEFEFF7),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1B2050),
      onPrimary: Color(0xffFFFFFF),
      onSecondary: Color(0xff8F94BC),
      inversePrimary: Color(0xFF5A4FE0),
      onPrimaryFixed: Color(0xff3A3F86),
    ),
  );

  // ===================== DARK THEME =====================
  // No dark palette defined in the current spec — left as-is until provided

  ThemeData get darkTheme => ThemeData(
    textTheme: GoogleFonts.manropeTextTheme(),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(onPrimary: Color(0xffFFFFFF)),
  );
}

// /// Tokens from the spec that don't have a dedicated ColorScheme slot —
// /// use these directly where the spec calls for them.
// class AppExtraColors {
//   static const neutral500 = Color(0xFF9B9797); // placeholder text, disabled labels
//   static const neutral600 = Color(0xFF7D7979); // kickers, metadata, inactive nav
//   static const neutral800 = Color(0xFF444141); // body copy on tinted fills
//   static const accent2_700 = Color(0xFFAA0B56); // error/attention body text (contrast-safe)
// }
