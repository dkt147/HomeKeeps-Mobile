import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/auth/three_things_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class HomeWalletScreen extends StatelessWidget {
  const HomeWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'Your home.\nOne wallet.',
                style: AppTextStyles.heading.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: 20.h),

              // Main Graphic Container
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Appliance Graphic
                    Image.asset(scale: 1.9, AppAssets.washermachine),

                    // Glassmorphism Badge (Top Right)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Every brand',
                                  style: AppTextStyles.small.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  'Every store',
                                  style: AppTextStyles.small.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // "Everything kept" Card
              Container(
                width: 230.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Color(0xff292C47),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Everything kept',
                      style: AppTextStyles.medium.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Receipt · warranty · serial number',
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3-Column Stats Section
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: '6–8',
                      subtitle: 'appliances in a home',
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      title: '3',
                      subtitle: 'minutes to set up',
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      title: '0',
                      subtitle: 'paperwork to hunt',
                      context: context,
                    ),
                  ),
                ],
              ),
              Spacer(),

              // Bottom CTA Button
              PrimaryButton(
                bg: Theme.of(context).colorScheme.onPrimary,
                textcolor: Color(0xff1B2050),
                onTap: () {
                  Get.to(
                    () => ThreeThingsScreen(),
                    transition: Transition.rightToLeftWithFade,
                  );
                },
                title: 'Open my wallet',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Color(0xff292C47),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.regular.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.small.copyWith(
              fontSize: 11.sp,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
