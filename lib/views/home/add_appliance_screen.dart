import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';

import 'package:home_keeps/models/product_category_model.dart';
import 'package:home_keeps/views/home/camera_capture_screen.dart';
import 'package:home_keeps/views/home/manual_entry_screen.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';

class AddApplianceMethodScreen extends StatefulWidget {
  const AddApplianceMethodScreen({super.key});

  @override
  State<AddApplianceMethodScreen> createState() =>
      _AddApplianceMethodScreenState();
}

class _AddApplianceMethodScreenState extends State<AddApplianceMethodScreen> {
  late final ProductController productController;

  @override
  void initState() {
    super.initState();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => productController.getCategories(),
    );
  }

  // Category name se icon match — naya category type aaye to yahan add kar dein.
  String _iconForCategory(String? name) {
    final n = (name ?? '').toLowerCase();
    if (n.contains('wash')) return "assets/images/q-washer.png";
    if (n.contains('dryer')) return "assets/images/q-washer.png";
    if (n.contains('fridge') || n.contains('refrigerator')) {
      return AppAssets.refrigerator;
    }
    if (n.contains('dishwasher')) return AppAssets.diswasher;
    if (n.contains('oven')) return AppAssets.oven;
    if (n.contains('air condition') || n == 'ac') return AppAssets.ac;
    if (n.contains('television') || n == 'tv') return AppAssets.tv;
    if (n.contains('microwave')) return AppAssets.microwave;
    return AppAssets.horizontaldot;
  }

  void _onSelectCategory({String? categoryId, required String categoryName}) {
    Get.to(
      () => ManualEntryScreen(
        categoryId: categoryId.toString(),
        categoryName: categoryName,
      ),
      transition: Transition.rightToLeft,
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              child: Center(child: Image.asset(icon, scale: 5)),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: Center(
                child: Text(
                  title,
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

  Widget _buildCategoriesGridSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        return AppSkeleton(
          width: double.infinity,
          height: double.infinity,
          radius: 20,
        );
      },
    );
  }

  Widget _buildCategoriesError() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            Text(
              "Couldn't load categories",
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            TextButton(
              onPressed: () => productController.getCategories(),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GetBuilder<ProductController>(
      builder: (controller) {
        if (controller.isCategoriesLoading) {
          return _buildCategoriesGridSkeleton();
        }

        if (controller.categoriesError) {
          return _buildCategoriesError();
        }

        final categories = controller.categoriesModel?.data ?? [];

        // API list + hamesha "Something else" fallback aakhir mein
        final itemCount = categories.length + 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            if (index == categories.length) {
              return _buildCategoryCard(
                title: 'Something else',
                icon: AppAssets.horizontaldot,
                onTap: () => _onSelectCategory(categoryName: 'Something else'),
              );
            }

            final ProductCategory category = categories[index];

            return _buildCategoryCard(
              title: category.name ?? '',
              icon: _iconForCategory(category.name),
              onTap: () => _onSelectCategory(
                categoryId: category.id,
                categoryName: category.name ?? '',
              ),
            );
          },
        );
      },
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
              Text(
                'STEP 1 OF 3',
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'What are we adding?',
                style: AppTextStyles.semiBold.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 20.h),

              _buildCategoriesGrid(),

              SizedBox(height: 28.h),
              Text(
                'OR SKIP THE TYPING',
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  _buildQuickActionCard(
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
