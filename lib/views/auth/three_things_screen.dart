import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/auth/day_it_break_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class ThreeThingsScreen extends StatelessWidget {
  const ThreeThingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Small Brand Tag
              Text(
                '{{ BRANDNAME }}',
                style: AppTextStyles.buttonLabel.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(height: 10.h),

              // Main Header
              Text(
                'Three things\nyou get.',
                style: AppTextStyles.heading.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Scrollable Content Layout
              ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.kitchen),
                      fit: BoxFit
                          .cover, // Changed to cover so it fills the card completely
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 1. Bottom Dark Gradient Overlay for text contrast
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.3, 1.0],
                              colors: [
                                Colors.transparent,
                                const Color(
                                  0xFF282C3F,
                                ).withOpacity(0.95), // Dark bottom shadow
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 2. Text Content positioned at the bottom
                      Positioned(
                        left: 20.w,
                        right: 20.w,
                        bottom: 20.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Every appliance in one\nplace',
                              style: AppTextStyles.body.copyWith(
                                height: 1.0,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Receipt, warranty dates and serial number, kept for you.',
                              style: AppTextStyles.small.copyWith(
                                fontSize: 11.sp,
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Middle Row Cards (Clock + Wrench)
              Row(
                children: [
                  // Clock Card (Light)
                  Expanded(
                    child: Container(
                      height: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Color(0xFF384371),
                            size: 26,
                          ),
                          Spacer(),
                          Text(
                            'We watch the\nclock',
                            style: AppTextStyles.buttonLabel.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Not just that warranty exists — how much is left.',
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Wrench Card (Dark Blue)
                  Expanded(
                    child: Container(
                      height: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.build_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          Spacer(),
                          Text(
                            'One button when it breaks',
                            style: AppTextStyles.buttonLabel.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'We find who pays, and we chase it.',
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Bottom Card (Receipt Photo)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Mock Receipt Icon Container
                    Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF1F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Image.asset(
                          AppAssets.receipt,
                          scale: 9.5,
                          // width: 24,
                          // height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),

                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Photograph the receipt once',
                            style: AppTextStyles.medium1.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'We read the store, date, price and model off it.',
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),

              // Bottom CTA Button
              PrimaryButton(
                onTap: () {
                  Get.to(
                    () => DayItBreaksScreen(),
                    transition: Transition.rightToLeftWithFade,
                  );
                },
                title: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Visual helper widgets for mock graphics
  Widget _buildMockFridge() {
    return Container(
      width: 50,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 3, height: 16, color: const Color(0xFF384371)),
          const Divider(color: Colors.white30, height: 12),
          Container(width: 3, height: 24, color: const Color(0xFF384371)),
        ],
      ),
    );
  }

  Widget _buildMockHeater() {
    return Container(
      width: 55,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          4,
          (index) => Container(
            width: 3,
            margin: const EdgeInsets.symmetric(vertical: 12),
            color: const Color(0xFF384371).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildMockOven() {
    return Container(
      width: 55,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => const CircleAvatar(
                radius: 2,
                backgroundColor: Color(0xFF384371),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF131835).withOpacity(0.7),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
