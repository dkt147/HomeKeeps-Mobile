import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/auth/open_wallet_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class DayItBreaksScreen extends StatelessWidget {
  const DayItBreaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '{{ BRANDNAME }}',
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                    Text(
                      'The day it breaks',
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Main Graphic Card (Appliance Frame Container)
              Image.asset(AppAssets.fault),

              // Hero Heading
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'One button.\nNo receipt\nhunt.',
                      style: AppTextStyles.heading.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context: context,
                            title: 'An answer in 2 seconds',
                            description:
                                'Maker\'s warranty, our protection, or nowhere — and we route accordingly.',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            context: context,
                            title: 'Tracked to\nclosure',
                            description:
                                'Even when the maker handles it, we check after 3 days it was resolved.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Bottom Primary Action Button
                    PrimaryButton(
                      bg: Theme.of(context).colorScheme.onPrimary,
                      textcolor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        Get.to(
                          () => OpenWalletScreen(),
                          transition: Transition.rightToLeftWithFade,
                        );
                      },
                      title: 'Continue',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

      decoration: BoxDecoration(
        color: Color(0xff292C47),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.regular.copyWith(
              height: 1.1,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: AppTextStyles.small.copyWith(
              fontSize: 11.sp,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to replicate the vertical grid pattern graphic
class GridGraphicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E3B68).withOpacity(0.5)
      ..strokeWidth = 1.5;

    const int numberOfVerticalLines = 8;
    final double spacing = size.width / (numberOfVerticalLines + 1);

    // Draw vertical bars
    for (int i = 1; i <= numberOfVerticalLines; i++) {
      final double x = spacing * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
