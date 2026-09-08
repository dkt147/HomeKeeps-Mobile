import 'package:get/get.dart';
import 'package:home_keeps/views/translations/ar_sa.dart';
import 'package:home_keeps/views/translations/en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'ar_SA': arSA};
}
