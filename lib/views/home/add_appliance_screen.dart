import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/home/camera_capture_screen.dart';
import 'package:home_keeps/views/home/manual_entry_screen.dart';

class ApplianceCategory {
  final String title;
  final String icon;

  const ApplianceCategory({required this.title, required this.icon});
}

class AddApplianceMethodScreen extends StatelessWidget {
  const AddApplianceMethodScreen({super.key});

  final List<ApplianceCategory> _categories = const [
    ApplianceCategory(
      title: 'Washing machine',
      icon: "assets/images/q-washer.png",
    ),
    ApplianceCategory(title: 'Fridge', icon: AppAssets.refrigerator),
    ApplianceCategory(title: 'Dishwasher', icon: AppAssets.diswasher),
    ApplianceCategory(title: 'Oven', icon: AppAssets.oven),
    ApplianceCategory(title: 'Air conditioner', icon: AppAssets.ac),
    ApplianceCategory(title: 'Television', icon: AppAssets.tv),
    ApplianceCategory(
      title: 'Tumble dryer',
      icon: "assets/images/q-washer.png",
    ),
    ApplianceCategory(title: 'Microwave', icon: AppAssets.microwave),
    ApplianceCategory(title: 'Something else', icon: AppAssets.horizontaldot),
  ];

  void _onSelectCategory(String category) {
    Get.to(() => ManualEntryScreen(), transition: Transition.rightToLeft);
  }

  Widget _buildCategoryCard(ApplianceCategory item, BuildContext context) {
    return GestureDetector(
      onTap: () => _onSelectCategory(item.title),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
              child: Center(child: Image.asset(item.icon, scale: 5)),
            ),
            SizedBox(height: 8.h),

            Expanded(
              child: Center(
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 15.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 24.sp,
                color: Theme.of(context).colorScheme.onPrimaryFixed,
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 18.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: AppTextStyles.small.copyWith(
                  fontSize: 11.sp,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        surfaceTintColor: Colors.transparent,
        leadingWidth: 100.w,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              children: [
                Icon(
                  Icons.close,
                  size: 18.sp,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Cancel',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 15.sp,

                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header indicator
              Text(
                'STEP 1 OF 3',
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 4.h),

              // Title
              Text(
                'What are we adding?',
                style: AppTextStyles.semiBold.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 20.h),

              // 3x3 Grid of Categories
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  return _buildCategoryCard(_categories[index], context);
                },
              ),

              SizedBox(height: 28.h),

              // Kicker for lower actions
              Text(
                'OR SKIP THE TYPING',
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 10.h),

              // Photo Shortcut Cards
              Row(
                children: [
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.receipt_long_outlined,
                    title: 'Photograph the receipt',
                    subtitle: 'We read the details',
                    onTap: () {
                      Get.to(
                        () => const CameraCaptureScreen(
                          captureType: CaptureType.invoice,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  _buildQuickActionCard(
                    context: context,
                    icon: Icons.crop_free_outlined,
                    title: 'Photograph the label',
                    subtitle: 'Model and serial',
                    onTap: () {
                      Get.to(
                        () => const CameraCaptureScreen(
                          captureType: CaptureType.label,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
