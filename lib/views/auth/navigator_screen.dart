import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/navigation_controller.dart';
import 'package:home_keeps/views/documents/document_screen.dart';
import 'package:home_keeps/views/home/home_screen.dart';
import 'package:home_keeps/views/profile/profile_screen.dart';
import 'package:home_keeps/views/services/service_screen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  final NavigationController navigationController = Get.put(
    NavigationController(),
  );

  final List<Widget> _pages = [
    HomeDashboardScreen(),
    DocumentsScreen(),
    ServiceCasesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null && Get.arguments is int) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigationController.selectIndex(Get.arguments as int);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        extendBodyBehindAppBar: true,
        // drawer: OrganizerDrawer(),
        body: GetBuilder<NavigationController>(
          builder: (_) {
            return _pages[navigationController.selectedIndex];
          },
        ),
        bottomNavigationBar: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0,
          child: SafeArea(top: false, child: buildNavBar()),
        ),

        // floatingActionButton: Visibility(
        //   visible: MediaQuery.of(context).viewInsets.bottom == 0,
        //   child: buildNavBar(),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  // Custom bottom navigation bar
  Widget buildNavBar() {
    return GetBuilder<NavigationController>(
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          // margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildNavItem(index: 0, icon: Icons.house, label: "home".tr),
              buildNavItem(
                index: 1,
                icon: Icons.file_present_outlined,
                label: "documents".tr,
              ),
              buildNavItem(
                index: 2,
                icon: Icons.build_rounded,
                label: "service".tr,
              ),

              buildNavItem(index: 3, icon: Icons.person, label: "profile".tr),
            ],
          ),
        );
      },
    );
  }

  Widget buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    bool isSelected = navigationController.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        navigationController.selectIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryFixed
                : Theme.of(context).colorScheme.onSecondary,
          ),
          6.h.verticalSpace,
          Text(
            label,
            style: AppTextStyles.buttonLabel.copyWith(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryFixed
                  : Theme.of(context).colorScheme.onSecondary,
              fontSize: 12.sp,
              // fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
