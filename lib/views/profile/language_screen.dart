import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/language_controller.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late final LanguageController languageController;
  String selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en', 'country': 'US'},
    {'name': 'Spanish', 'code': 'es', 'country': 'ES'},
    {'name': 'Italian', 'code': 'it', 'country': 'IT'},
    {'name': 'French', 'code': 'fr', 'country': 'FR'},
    {'name': 'Chinese', 'code': 'zh', 'country': 'CN'},
    {'name': 'Arabic', 'code': 'ar', 'country': 'SA'},
  ];

  @override
  void initState() {
    super.initState();
    try {
      languageController = Get.find<LanguageController>();
    } catch (e) {
      languageController = Get.put(LanguageController());
    }
    final currentLang = languageController.currentLocale.languageCode;
    final lang = languages.firstWhere(
      (l) => l['code'] == currentLang,
      orElse: () => languages[0],
    );
    selectedLanguage = lang['name']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 150.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_backspace,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  "Back",
                  style: AppTextStyles.buttonLabel.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              children: [
                Text(
                  'select_language'.tr,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 20.h),
                ...languages.map(
                  (language) => _buildLanguageOption(
                    language['name']!,
                    language['code']!,
                    language['country']!,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: PrimaryButton(
              onTap: () {
                final selectedLang = languages.firstWhere(
                  (lang) => lang['name'] == selectedLanguage,
                );

                // ✅ CHANGED: Use language controller
                languageController.changeLanguage(
                  selectedLang['code']!,
                  selectedLang['country']!,
                );

                Get.back();

                // ✅ ADDED: Show success message
                Get.snackbar(
                  'success'.tr,
                  'language_changed'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              title: 'save'.tr, // ✅ CHANGED
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, String code, String country) {
    final isSelected = selectedLanguage == language;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),

                color: isSelected ? Color(0xFF99E0FF) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
