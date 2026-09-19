import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/auth_controller.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/data/response/status.dart';
import 'package:home_keeps/views/home/add_appliance_screen.dart';
import 'package:home_keeps/views/home/appliances_detail_screen.dart';
import 'package:home_keeps/views/home/out_of_cover_screen.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  late final AuthController controller;
  late final ProductController productController;
  @override
  void initState() {
    super.initState();
    try {
      controller = Get.find<AuthController>();
    } catch (e) {
      controller = Get.put(AuthController());
    }
    try {
      productController = Get.find<ProductController>();
    } catch (e) {
      productController = Get.put(ProductController());
    }

    if (controller.profile == null) {
      controller.fetchProfile();
    }
    productController.getProduct();
    productController.getHomeSummary();
    productController.getWarrantyCase();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'GOOD MORNING';
    if (hour >= 12 && hour < 17) return 'GOOD AFTERNOON';
    if (hour >= 17 && hour < 21) return 'GOOD EVENING';
    return 'GOOD NIGHT';
  }

  String _firstName() {
    final fullName = controller.profile?.customer?.fullName?.trim();
    if (fullName == null || fullName.isEmpty) return '';
    return fullName.split(' ').first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle Header
                    GetBuilder<AuthController>(
                      builder: (controller) {
                        final firstName = _firstName();
                        final greeting = _greeting();
                        return Text(
                          firstName.isEmpty
                              ? greeting
                              : '$greeting, $firstName',
                          style: AppTextStyles.medium2.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Main Title
                    Text(
                      'Your home',
                      style: AppTextStyles.heading.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 32.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Top Metric Row Cards
                    GetBuilder<ProductController>(
                      init: ProductController(),
                      initState: (_) {
                        final controller = Get.find<ProductController>();
                        controller.getHomeSummary();
                      },
                      builder: (controller) {
                        return Row(
                          children: [
                            Expanded(
                              child: controller.homeSummaryModel == null
                                  ? const AppSkeleton(
                                      width: double.infinity,
                                      height: 68,
                                      radius: 16,
                                    )
                                  : _buildMetricCard(
                                      context: context,
                                      value:
                                          '${controller.homeSummaryModel?.total ?? 0}',
                                      label: 'appliances',
                                      isHighlighted: false,
                                    ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: controller.homeSummaryModel == null
                                  ? const AppSkeleton(
                                      width: double.infinity,
                                      height: 68,
                                      radius: 16,
                                    )
                                  : _buildMetricCard(
                                      context: context,
                                      value:
                                          '${controller.homeSummaryModel?.underWarranty ?? 0}',
                                      label: 'covered',
                                      isHighlighted: false,
                                    ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: controller.homeSummaryModel == null
                                  ? const AppSkeleton(
                                      width: double.infinity,
                                      height: 68,
                                      radius: 16,
                                    )
                                  : _buildMetricCard(
                                      context: context,
                                      value:
                                          '${controller.homeSummaryModel?.uncovered ?? 0}',
                                      label: 'uncovered',
                                      isHighlighted: false,
                                    ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: controller.homeSummaryModel == null
                                  ? const AppSkeleton(
                                      width: double.infinity,
                                      height: 68,
                                      radius: 16,
                                    )
                                  : _buildMetricCard(
                                      context: context,
                                      value:
                                          '${controller.homeSummaryModel?.needsAction ?? 0}',
                                      label: 'needs you',
                                      isHighlighted: true,
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20.h),

                    GetBuilder<ProductController>(
                      init: ProductController(),
                      initState: (_) {
                        final controller = Get.find<ProductController>();
                        controller.getHomeSummary();
                        controller.getWarrantyCase();
                      },
                      builder: (controller) {
                        return Column(
                          children: [
                            controller.warrantyCaseStatusModel == null
                                ? _buildWorthDoingSkeleton()
                                : _buildWorthDoingCard(context, controller),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Appliance List Items
                    GetBuilder<ProductController>(
                      builder: (ctrl) {
                        if (ctrl.apiResponse.status == Status.loading) {
                          return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 2,
                            separatorBuilder: (_, __) => 12.verticalSpace,
                            itemBuilder: (_, __) {
                              return _buildApplianceSkeleton();
                            },
                          );
                        }

                        final allItems = ctrl.productModel?.data ?? [];

                        // Empty State
                        if (allItems.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 30.h,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.home_repair_service_outlined,
                                  size: 40.sp,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'No appliances found',
                                  style: AppTextStyles.semiBold.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'You don’t have any appliances added yet.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.small.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allItems.length,
                          shrinkWrap: true,
                          separatorBuilder: (_, __) => 12.verticalSpace,
                          itemBuilder: (context, index) {
                            final item = allItems[index];

                            // Convert health score from 0-100 to 0.0-1.0
                            final healthScore =
                                item.healthScore?.toDouble() ?? 0.0;

                            return _buildApplianceCard(
                              context: context,
                              title: item.name ?? '',
                              subtitle: item.serialNumber ?? '',

                              // LinearProgressIndicator expects 0.0 - 1.0
                              progress: (healthScore / 100).clamp(0.0, 1.0),

                              progressText:
                                  "${item.warrantyLeft ?? ''} left of maker's warranty",

                              imageWidget: AppAssets.diswasher,

                              onTap: () {
                                Get.to(
                                  () => ApplianceDetailScreen(
                                    id: item.id.toString(),
                                    // daysLeft: 46,
                                    // applianceName: item.name ?? '',
                                    // model: 'SMV4HVX00E',
                                    // boughtDate: '12 Oct 2024',
                                    // store: 'Electra Home, Rishon LeZion',
                                    // price: 'ILS 2,790',
                                    // serial: item.serialNumber ?? '',
                                    // warrantyEndDate: '12.10.2026',
                                    // serviceHistory: [
                                    //   ServiceHistoryItem(
                                    //     title: 'Water not draining',
                                    //     closedDate: '03.02.2026',
                                    //     caseNumber: '#3910',
                                    //   ),
                                    //   ServiceHistoryItem(
                                    //     title: 'Door seal replaced',
                                    //     closedDate: '18.06.2025',
                                    //     caseNumber: '#2604',
                                    //   ),
                                    // ],
                                  ),
                                  transition: Transition.rightToLeft,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    // SizedBox(height: 12.h),

                    // _buildApplianceCard(
                    //   context: context,
                    //   title: 'Samsung fridge',
                    //   subtitle: 'RS68A8840S9',
                    //   progress: 0.65,
                    //   progressText: 'Covered until 12 Apr 2029',
                    //   imageWidget: AppAssets.refrigerator,
                    //   onTap: () {
                    //     // Get.to(
                    //     //   () => ClosingOnSiteScreen(),
                    //     //   transition: Transition.rightToLeft,
                    //     // );
                    //   },
                    // ),
                    // SizedBox(height: 12.h),

                    // _buildApplianceCard(
                    //   context: context,
                    //   title: 'Electra air conditioner',
                    //   subtitle: '9 years old',
                    //   tagText: 'No coverage',
                    //   imageWidget: AppAssets.ac,
                    //   onTap: () {},
                    // ),
                    // SizedBox(height: 12.h),

                    // _buildApplianceCard(
                    //   context: context,
                    //   subtitle: '',
                    //   title: 'Sony television',
                    //   infoBoxText:
                    //       "No delivery date, so we can't show coverage.",
                    //   actionText: "Add it",
                    //   imageWidget: AppAssets.tv,
                    //   onTap: () {},
                    // ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Floating Button
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
              child: PrimaryButton(
                onTap: () {
                  Get.to(
                    () => AddApplianceMethodScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
                title: 'add_appliance'.tr,
                prefixIcon: Icon(Icons.add, size: 20.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TOP METRIC CARDS ---
  Widget _buildMetricCard({
    required String value,
    required String label,
    required bool isHighlighted,
    required BuildContext context,
  }) {
    return Container(
      height: 68.h,
      decoration: BoxDecoration(
        color: isHighlighted
            ? Theme.of(context).colorScheme.inversePrimary
            : Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.screenTitle.copyWith(
              color: isHighlighted
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTextStyles.small.copyWith(
              color: isHighlighted
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.onSecondary,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  // --- WORTH DOING NOW BANNER ---
  Widget _buildWorthDoingCard(
    BuildContext context,
    ProductController controller,
  ) {
    final warrantyCase = controller.warrantyCaseStatusModel;

    final manufacturerName = warrantyCase?.product?.manufacturerName ?? '';
    final category = warrantyCase?.product?.categoryName ?? '';

    final daysRemaining =
        warrantyCase?.manufacturerWarranty?.daysRemaining ?? 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WORTH DOING NOW',
                  style: AppTextStyles.medium2.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                SizedBox(height: 10.h),

                SizedBox(
                  width: 190.w,
                  child: Text(
                    "$manufacturerName $category warranty ends in $daysRemaining days",
                    style: AppTextStyles.semiBold.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      height: 1.2,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                SizedBox(
                  width: 170.w,
                  child: Text(
                    "You can extend it now, while it's still covered.",
                    style: AppTextStyles.small.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      height: 1.3,
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                PrimaryButton(
                  bg: Theme.of(context).colorScheme.onPrimary,
                  textcolor: Theme.of(context).colorScheme.primary,
                  width: 190.w,
                  onTap: () {
                    Get.to(
                      () => OutOfCoverScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  title: "See what's covered",
                ),
              ],
            ),
          ),

          Image.asset(AppAssets.diswasher),
        ],
      ),
    );
  }

  Widget _buildApplianceSkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          AppSkeleton(width: 55.w, height: 55.w, radius: 12),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(width: 130.w, height: 14.h, radius: 4),

                SizedBox(height: 7.h),

                AppSkeleton(width: 90.w, height: 11.h, radius: 4),

                SizedBox(height: 10.h),

                AppSkeleton(width: double.infinity, height: 4.h, radius: 4),

                SizedBox(height: 7.h),

                AppSkeleton(width: 100.w, height: 10.h, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorthDoingSkeleton() {
    return Container(
      width: double.infinity,
      height: 250.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(width: 110.w, height: 12.h, radius: 4),
                SizedBox(height: 12.h),

                AppSkeleton(width: 170.w, height: 38.h, radius: 6),
                SizedBox(height: 10.h),

                AppSkeleton(width: 160.w, height: 30.h, radius: 6),
                SizedBox(height: 18.h),

                AppSkeleton(width: 190.w, height: 42.h, radius: 22),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: AppSkeleton(width: 100.w, height: 150.h, radius: 12),
          ),
        ],
      ),
    );
  }

  // --- APPLIANCE LIST ITEM ---
  Widget _buildApplianceCard({
    required String title,
    required String subtitle,
    required String imageWidget,
    required VoidCallback onTap,
    required BuildContext context,
    double? progress,
    String? progressText,
    String? tagText,
    String? infoBoxText,
    String? actionText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            // Thumbnail Image Box
            Image.asset(imageWidget, scale: 4.0),
            SizedBox(width: 14.w),

            // Item Information Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.semiBold.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.small.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),

                  // Progress Bar Style (If Active Warranty)
                  if (progress != null) ...[
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4.h,
                        backgroundColor: const Color(0xFFE2E6F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF5A4FE0),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      progressText ?? '',
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],

                  // Tag Pill Style (e.g. No Coverage)
                  if (tagText != null) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECEFF6),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        tagText,
                        style: AppTextStyles.small.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ],

                  // Highlighted Notice Box (e.g. Missing Delivery Date)
                  if (infoBoxText != null) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF0F8),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 14.sp,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.small.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                                children: [
                                  TextSpan(text: infoBoxText),
                                  if (actionText != null) ...[
                                    const TextSpan(text: ' '),
                                    TextSpan(
                                      text: actionText,
                                      style: AppTextStyles.small.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MOCK PRODUCT RENDERS ---
  Widget _buildDishwasherGraphic() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E6F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 12.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            color: const Color(0xFF384371),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 12.w, height: 3.h, color: Colors.white54),
                Row(
                  children: List.generate(
                    3,
                    (i) => Container(
                      width: 2.w,
                      height: 2.w,
                      margin: EdgeInsets.only(left: 2.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 1.5.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            color: const Color(0xFFD6DCED),
          ),
        ],
      ),
    );
  }

  Widget _buildFridgeGraphic() {
    return Container(
      width: 28.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFD6DCED)),
      ),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Container(width: 2.w, height: 8.h, color: const Color(0xFF434C7A)),
          const Divider(color: Color(0xFFD6DCED), height: 10),
          Container(width: 2.w, height: 12.h, color: const Color(0xFF434C7A)),
        ],
      ),
    );
  }

  Widget _buildAcGraphic() {
    return Container(
      width: 46.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFFD6DCED)),
      ),
      child: Center(
        child: Container(
          width: 8.w,
          height: 3.h,
          color: const Color(0xFF8E95A5),
        ),
      ),
    );
  }

  Widget _buildTvGraphic() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44.w,
          height: 28.h,
          decoration: BoxDecoration(
            color: const Color(0xFF282E54),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Container(width: 12.w, height: 3.h, color: const Color(0xFF8E95A5)),
      ],
    );
  }
}
