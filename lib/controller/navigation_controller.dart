import 'package:get/get.dart';

class NavigationController extends GetxController {
  int selectedIndex = 0;

  void selectIndex(int index) {
    selectedIndex = index;
    update();
  }
}
