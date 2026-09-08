import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class OutOfCoverScreen extends StatelessWidget {
  final String kickerText;
  final String title;
  final String subtitle;
  final String priceText;
  final String priceUnit;
  final VoidCallback? onBookTap;
  final VoidCallback? onShowReplacementsTap;
  final VoidCallback? onNotNowTap;

  const OutOfCoverScreen({
    super.key,
    this.kickerText = 'ELECTRA AIR CONDITIONER · 9 YEARS OLD',
    this.title = "This one's out of cover",
    this.subtitle =
        "The maker's warranty ran out in 2019 and there's no protection on it. We can still send someone today.",
    this.priceText = '349',
    this.priceUnit = 'ILS',
    this.onBookTap,
    this.onShowReplacementsTap,
    this.onNotNowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // Kicker Header
                    Text(
                      kickerText.toUpperCase(),
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Screen Title
                    Text(
                      title,
                      style: AppTextStyles.semiBold.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Subtitle Body
                    Text(
                      subtitle,
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Paid Visit Pricing Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A VISIT YOU PAY FOR',
                            style: AppTextStyles.medium2.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Large Price Display
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$priceUnit $priceText',
                                style: AppTextStyles.semiBold.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'including VAT',
                                style: AppTextStyles.small.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Bullet List Items
                          _featureRow(
                            context: context,
                            icon: Icons.check,
                            iconColor: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                            text: 'A technician comes out and diagnoses it',
                          ),
                          _featureRow(
                            context: context,
                            icon: Icons.check,
                            iconColor: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                            text: 'Up to an hour of work included',
                          ),
                          _featureRow(
                            context: context,
                            icon: Icons.check,
                            iconColor: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                            text:
                                'The fee comes off the repair if you go ahead',
                          ),
                          _featureRow(
                            context: context,
                            icon: Icons.close,
                            iconColor: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                            text: 'Parts quoted separately — you approve first',
                          ),
                          SizedBox(height: 20.h),

                          // Main Action Button
                          PrimaryButton(
                            onTap: onBookTap ?? () {},
                            title: 'Book a visit for $priceUnit $priceText',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Financial Analysis & Alternatives Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WORTH KNOWING BEFORE YOU DECIDE',
                            style: AppTextStyles.medium2.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "You've spent ILS 1,840 on this unit in two years",
                            style: AppTextStyles.semiBold.copyWith(
                              fontSize: 15.sp,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Progress Bar 1 - Repairs
                          _costProgressRow(
                            context: context,
                            label: 'Repairs so far',
                            amountText: 'ILS 1,840',
                            progress: 0.58,
                            activeColor: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,
                          ),
                          SizedBox(height: 12.h),

                          // Progress Bar 2 - Replacement
                          _costProgressRow(
                            context: context,
                            label: 'A new one, fitted',
                            amountText: 'ILS 3,200',
                            progress: 1.0,
                            activeColor: Theme.of(
                              context,
                            ).colorScheme.onPrimaryFixed,
                          ),
                          SizedBox(height: 20.h),

                          // AC Preview Thumbnails
                          Row(
                            children: List.generate(
                              3,
                              (index) => Expanded(
                                child: Container(
                                  height: 64.h,
                                  margin: EdgeInsets.only(
                                    right: index == 2 ? 0 : 8.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4FB),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      AppAssets.ac,
                                      scale: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Replacement Button
                          GestureDetector(
                            onTap: onShowReplacementsTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E7F2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                'Show me replacements',
                                style: AppTextStyles.small.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryFixed,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Disclaimer Footer
                    Text(
                      "We only show alternatives after we've answered the service question. Repairing it is still the first option on this screen.",
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom Secondary Action Text Button
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: GestureDetector(
                onTap: onNotNowTap ?? () => Navigator.of(context).maybePop(),
                child: Text(
                  'Not now, thanks',
                  style: AppTextStyles.semiBold.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row Item for Pricing Feature Specs
  Widget _featureRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: iconColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Cost Comparison Indicator Line
  Widget _costProgressRow({
    required String label,
    required String amountText,
    required double progress,
    required Color activeColor,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            Text(
              amountText,
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 13.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(3.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.h,
            backgroundColor: const Color(0xFFE5E7F2),
            valueColor: AlwaysStoppedAnimation<Color>(activeColor),
          ),
        ),
      ],
    );
  }
}
