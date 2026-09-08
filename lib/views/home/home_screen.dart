import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/documents/closing_onsite_screen.dart';
import 'package:home_keeps/views/documents/read_receipt_screen.dart';
import 'package:home_keeps/views/home/add_appliance_screen.dart';
import 'package:home_keeps/views/home/appliances_detail_screen.dart';
import 'package:home_keeps/views/home/extended_cover_screen.dart';
import 'package:home_keeps/views/home/out_of_cover_screen.dart';
import 'package:home_keeps/views/home/suggest_item_screen.dart';
import 'package:home_keeps/views/home/warranty_offer_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

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
                    Text(
                      'GOOD MORNING, DANA',
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            context: context,
                            value: '7',
                            label: 'appliances',
                            isHighlighted: false,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildMetricCard(
                            context: context,
                            value: '5',
                            label: 'covered',
                            isHighlighted: false,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildMetricCard(
                            context: context,
                            value: '2',
                            label: 'uncovered',
                            isHighlighted: false,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildMetricCard(
                            context: context,
                            value: '1',
                            label: 'needs you',
                            isHighlighted: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Featured Banner Card ("Worth doing now")
                    _buildWorthDoingCard(context),
                    SizedBox(height: 16.h),

                    // Appliance List Items
                    _buildApplianceCard(
                      context: context,
                      title: 'Bosch dishwasher',
                      subtitle: 'SMV4HVX00E',
                      progress: 0.15,
                      progressText: "46 days left of maker's warranty",
                      imageWidget: AppAssets.diswasher,
                      onTap: () {
                        Get.to(
                          () => ApplianceDetailScreen(
                            daysLeft: 46,
                            applianceName: 'Bosch dishwasher',
                            model: 'SMV4HVX00E',
                            // coverageLabel:
                            //     'Manufacturer warranty · 46 days left',
                            boughtDate: '12 Oct 2024',
                            store: 'Electra Home, Rishon LeZion',
                            price: 'ILS 2,790',
                            serial: 'FD9902 004417',
                            warrantyEndDate: '12.10.2026',
                            serviceHistory: [
                              ServiceHistoryItem(
                                title: 'Water not draining',
                                closedDate: '03.02.2026',
                                caseNumber: '#3910',
                              ),
                              ServiceHistoryItem(
                                title: 'Door seal replaced',
                                closedDate: '18.06.2025',
                                caseNumber: '#2604',
                              ),
                            ],
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                    SizedBox(height: 12.h),

                    _buildApplianceCard(
                      context: context,
                      title: 'Samsung fridge',
                      subtitle: 'RS68A8840S9',
                      progress: 0.65,
                      progressText: 'Covered until 12 Apr 2029',
                      imageWidget: AppAssets.refrigerator,
                      onTap: () {
                        // Get.to(
                        //   () => ClosingOnSiteScreen(),
                        //   transition: Transition.rightToLeft,
                        // );
                      },
                    ),
                    SizedBox(height: 12.h),

                    _buildApplianceCard(
                      context: context,
                      title: 'Electra air conditioner',
                      subtitle: '9 years old',
                      tagText: 'No coverage',
                      imageWidget: AppAssets.ac,
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),

                    _buildApplianceCard(
                      context: context,
                      subtitle: '',
                      title: 'Sony television',
                      infoBoxText:
                          "No delivery date, so we can't show coverage.",
                      actionText: "Add it",
                      imageWidget: AppAssets.tv,
                      onTap: () {},
                    ),
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
  Widget _buildWorthDoingCard(BuildContext context) {
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
                  width: 170.w,
                  child: Text(
                    "Your Bosch dishwasher's warranty ends in 46 days",
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

                // Sub-button inside the card
                PrimaryButton(
                  bg: Theme.of(context).colorScheme.onPrimary,
                  textcolor: Theme.of(context).colorScheme.primary,
                  width: 190.w,
                  onTap: () {
                    // Get.to(
                    //   () => ExtendedWarrantyOfferScreen(
                    //     applianceName: 'Bosch dishwasher',
                    //     headline:
                    //         'Three more years of repairs, after Bosch stops covering it',
                    //     price: '₪690',
                    //     priceNote: 'once · covers 36 months',
                    //     covered: const [
                    //       'Mechanical and electrical breakdown',
                    //       'Technician call-out, labour and parts',
                    //       'Unlimited number of visits',
                    //       "Replacement if it can't be repaired",
                    //     ],
                    //     notCovered: const [
                    //       'Accidental damage, misuse and cosmetic wear',
                    //       'Faults that already exist today',
                    //       'Consumables: filters, seals, hoses',
                    //       'Commercial or business use',
                    //     ],
                    //     coverBegins: '13.10.2026',
                    //     waitingPeriod: '30 days from purchase',
                    //     yourSharePerClaim: '₪0',
                    //     claimLimit: '₪2,790',
                    //     term: '36 months',
                    //   ),
                    //   transition: Transition.rightToLeft,
                    // );
                  },
                  title: "See what's covered",
                ),
              ],
            ),
          ),
          Image.asset(AppAssets.diswasher),

          // Right Dishwasher Product Mockup
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
