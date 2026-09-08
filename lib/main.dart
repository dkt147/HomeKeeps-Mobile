import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/controller/language_controller.dart';
import 'package:home_keeps/resources/local_storage.dart';
import 'package:home_keeps/services/theme_service.dart';
import 'package:home_keeps/views/auth/home_wallet_screen.dart';
import 'package:home_keeps/views/auth/splash_screen.dart';
import 'package:home_keeps/views/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  await Firebase.initializeApp();
  Get.put(ThemeService(), permanent: true);
  Get.put(LanguageController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) {
        return GetBuilder<ThemeService>(
          builder: (themeService) {
            return GetMaterialApp(
              routingCallback: (routing) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              theme: themeService.lightTheme,
              // darkTheme: themeService.darkTheme,
              // themeMode: themeService.themeMode,
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              translations: AppTranslations(),
              locale: Get.find<LanguageController>().currentLocale,
              fallbackLocale: const Locale('en', 'US'),

              builder: (context, widget) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(1.0)),
                  child: widget!,
                );
              },

              // home: const SplashScreen(),
              home: HomeWalletScreen(),
            );
          },
        );
      },
    );
  }
}
