import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/home/repair_covered_screen.dart';

enum CoverageCheckStatus { done, pending }

class CoverageCheckItem {
  final String label;
  final CoverageCheckStatus status;

  const CoverageCheckItem({required this.label, required this.status});
}

class CheckingCoverageScreen extends StatefulWidget {
  final List<CoverageCheckItem> items;

  const CheckingCoverageScreen({
    super.key,
    this.items = const [
      CoverageCheckItem(
        label: 'Warranty dates read',
        status: CoverageCheckStatus.done,
      ),
      CoverageCheckItem(
        label: 'Invoice found',
        status: CoverageCheckStatus.done,
      ),
      CoverageCheckItem(
        label: 'Matching a service provider',
        status: CoverageCheckStatus.pending,
      ),
    ],
  });

  @override
  State<CheckingCoverageScreen> createState() => _CheckingCoverageScreenState();
}

class _CheckingCoverageScreenState extends State<CheckingCoverageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Timer(const Duration(seconds: 3), () {
    //   if (mounted) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (context) => const RepairCoveredScreen(
    //           manufacturer: 'Bosch',
    //           providerName: 'BSH Service Israel',
    //           providerPhoneDisplay: '*6110',
    //           providerHours: 'Sun–Thu 08:00–17:00',
    //           model: 'SMV4HVX00E',
    //           serial: 'FD9902 004417',
    //           caseReference: '#4471',
    //         ),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),

              // Shield glyph — pale accent tone, purely decorative here
              Icon(
                Icons.shield_outlined,
                size: 34.sp,
                color: theme.colorScheme.tertiary, // --color-accent300
              ),
              SizedBox(height: 16.h),

              Text(
                'Checking your coverage',
                style: AppTextStyles.screenTitle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),

              Text(
                'A few seconds while we look at your warranty dates, your '
                'invoice and who repairs this appliance.',
                style: AppTextStyles.body.copyWith(color: hintColor),
              ),
              SizedBox(height: 20.h),

              for (final item in widget.items)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      Icon(
                        item.status == CoverageCheckStatus.done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 16.sp,
                        color: item.status == CoverageCheckStatus.done
                            ? theme
                                  .colorScheme
                                  .primary // --color-accent700
                            : hintColor, // --color-neutral500
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item.label,
                        style: AppTextStyles.metaCaption.copyWith(
                          fontWeight: FontWeight.w400,
                          color: item.status == CoverageCheckStatus.done
                              ? theme.colorScheme.onSurface
                              : hintColor,
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Indeterminate progress sweep — navigation stays live behind it
              LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Light Grey Background Track
                      Container(
                        width: constraints.maxWidth,
                        height: 2.5,
                        color: const Color(0xFFE0E0E0),
                      ),
                      // Smooth Animating Blue Line
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: constraints.maxWidth * _animation.value,
                            height: 2.5,
                            color: Color(0xFF0088B0),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
