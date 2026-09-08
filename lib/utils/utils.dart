import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class Utils {
  static logInfo(String msg, {String? name}) {
    log(
      '\x1B[32m$msg\x1B[0m',
      name: name != null ? '\x1B[32m$name\x1B[0m' : "",
    );
  }

  static void logSuccess(String msg, {String? name}) {
    log(
      '\x1B[32m$msg\x1B[0m',
      name: name != null ? '\x1B[32m$name\x1B[0m' : "",
    );
  }

  /// Logs error messages in red color in the console.
  static logError(String msg, {String? name}) {
    log(
      '\x1B[31m$msg\x1B[0m',
      name: name != null ? '\x1B[31m$name\x1B[0m' : "",
    );
  }

  static void logC(String msg, {String? name}) {
    final random = math.Random();
    final colorCode = 30 + random.nextInt(7);
    log(
      '\x1B[${colorCode}m$msg\x1B[0m',
      name: name != null ? '\x1B[${colorCode}m$name\x1B[0m' : "",
    );
  }

  static OverlayEntry? _currentEntry;
  static void errorBar(String message) {
    final context = Get.context;
    if (context == null) return;

    _currentEntry?.remove();
    _currentEntry = null;

    OverlayState? overlay;
    try {
      overlay = Navigator.of(context, rootNavigator: true).overlay;
    } catch (_) {
      return;
    }

    if (overlay == null) return;

    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _currentEntry?.remove();
      _currentEntry = null;
    });
  }

  static OverlayEntry? _currentSuccessEntry;
  static void successBar(String message) {
    final context = Get.context;
    if (context == null) return;

    _currentSuccessEntry?.remove();
    _currentSuccessEntry = null;

    OverlayState? overlay;
    try {
      overlay = Navigator.of(context, rootNavigator: true).overlay;
    } catch (_) {
      return;
    }

    if (overlay == null) return;

    _currentSuccessEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentSuccessEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _currentSuccessEntry?.remove();
      _currentSuccessEntry = null;
    });
  }

  static Future<void> selectDate(
    BuildContext context, {
    required Function(DateTime) onDateSelected,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime today = DateTime.now();
    DateTime minAdult = DateTime(today.year - 18, today.month, today.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2040),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  static Future<void> pickProfileImage({
    required ImageSource source,
    required Function(File) onFileSelected,
  }) async {
    ImagePicker picker = ImagePicker();
    File? selectedFile;
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedFile = File(pickedFile.path);
        onFileSelected(selectedFile);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
    }
  }

  static toastMessage(String message, BuildContext? context) {
    if (context != null) {
      FToast toast = FToast();
      toast.init(context);
      toast.removeCustomToast();
      toast.showToast(
        child: Container(
          constraints: BoxConstraints(maxWidth: Get.height * 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SvgPicture.asset(
              //   // AppAssets.applogo,
              //   // height: 25.h,
              // ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  static String formatStatus(String raw) {
    if (raw.isEmpty) return raw;

    return raw
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .trim()
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  static String maskPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return '';

    if (phone.length <= 3) return phone;

    return '${phone.substring(0, 3)}${'*' * (phone.length - 3)}';
  }

  static bool isValidPhone(String phone) {
    final value = phone.trim();

    if (value.isEmpty) return false;

    final regex = RegExp(r'^[0-9+\-\s()]{7,15}$');
    return regex.hasMatch(value);
  }

  static bool isValidUrl(String url) {
    final value = url.trim();

    if (value.isEmpty) return false;

    return GetUtils.isURL(value);
  }

  static bool isStrongPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$');

    return regex.hasMatch(password);
  }

  static String getImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) {
      return "";
    }

    // Already a complete URL
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    return "https://api.foodieroulette.app$path";
  }
}
