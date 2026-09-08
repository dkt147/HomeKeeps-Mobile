import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/navigation_controller.dart';
import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class WarrantyPurchaseSuccessScreen extends StatelessWidget {
  final String applianceName; // "dishwasher"
  final String coverageEndDate; // "12.10.2029"
  final String amountPaid; // "₪690"
  final String certificateFileName; // "Warranty certificate"
  final String certificateMeta; // "PDF · HK-2026-004471"
  final String sentToPhoneNumber; // "+972 50-712-4488"

  const WarrantyPurchaseSuccessScreen({
    super.key,
    required this.applianceName,
    required this.coverageEndDate,
    required this.amountPaid,
    required this.certificateFileName,
    required this.certificateMeta,
    required this.sentToPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.verticalSpace,
              Icon(
                Icons.verified,
                size: 52.sp,
                color: theme.colorScheme.primary, // --color-accent
              ),
              SizedBox(height: 20.h),

              Text(
                'Your $applianceName is covered until $coverageEndDate',
                style: AppTextStyles.screenTitle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),

              Text(
                "Paid $amountPaid. The certificate now sits on the "
                "appliance's card, and we've sent you a copy on WhatsApp.",
                style: AppTextStyles.body.copyWith(color: hintColor),
              ),
              SizedBox(height: 28.h),

              // Certificate row
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 24.sp,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            certificateFileName,
                            style: AppTextStyles.listItemTitle.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            certificateMeta,
                            style: AppTextStyles.metaCaption.copyWith(
                              color: hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.file_download_outlined,
                        size: 20.sp,
                        color: hintColor,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Sent to
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 18.sp,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Sent to',
                    style: AppTextStyles.body.copyWith(color: hintColor),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    sentToPhoneNumber,
                    style: AppTextStyles.listItemTitle.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              PrimaryButton(
                onTap: () {
                  final navigationController = Get.find<NavigationController>();
                  navigationController.selectIndex(0);
                  Get.offAll(
                    () => NavigatorScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
                title: 'Back to the appliance',
              ),
              SizedBox(height: 16.h),

              Center(
                child: GestureDetector(
                  onTap: () {
                    final navigationController =
                        Get.find<NavigationController>();
                    navigationController.selectIndex(0);
                    Get.offAll(
                      () => NavigatorScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Text(
                    'Go to my wallet',
                    style: AppTextStyles.buttonLabel.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
