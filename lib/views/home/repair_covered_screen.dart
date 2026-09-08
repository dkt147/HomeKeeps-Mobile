import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class RepairCoveredScreen extends StatelessWidget {
  final String caseReference; // "24-10583"
  final String manufacturer; // "Bosch"
  final String providerName; // "BSH Service Israel"
  final String providerPhoneDisplay; // "*6110"
  final String providerHours; // "Sun–Thu 08:00–17:00"
  final String model; // "SMV4HVX00E"
  final String serial; // "FD9902 004417"
  final String purchaseDate; // "12 Oct 2024"

  const RepairCoveredScreen({
    super.key,
    this.caseReference = '24-10583',
    this.manufacturer = 'Bosch',
    this.providerName = 'BSH Service Israel',
    this.providerPhoneDisplay = '*6110',
    this.providerHours = 'Sun–Thu 08:00–17:00',
    this.model = 'SMV4HVX00E',
    this.serial = 'FD9902 004417',
    this.purchaseDate = '12 Oct 2024',
  });

  void _copyDetailsToClipboard(BuildContext context) {
    final textToCopy = 'Model: $model\nSerial: $serial\nBought: $purchaseDate';
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Details copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // Top Kicker Reference
                    Text(
                      'CASE $caseReference'.toUpperCase(),
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Screen Title
                    Text(
                      '$manufacturer will\nfix this, free',
                      style: AppTextStyles.semiBold.copyWith(
                        height: 1.1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Top Banner Card
                    Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,

                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Still under the maker's\nwarranty",
                                  style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 16.sp,

                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    height: 1.25,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Their own engineers handle it. Nothing to pay — not the call-out, not the parts.',
                                  style: AppTextStyles.small.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).scaffoldBackgroundColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Appliance Graphic Container
                          Image.asset(
                            "assets/images/q-dishwasher.png",
                            scale: 1.7,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // "WHO TO CALL" Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WHO TO CALL',
                            style: AppTextStyles.medium2.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            providerName,
                            style: AppTextStyles.semiBold.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '$providerPhoneDisplay · $providerHours',
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Call Button
                          PrimaryButton(
                            onTap: () {
                              // Add call intent trigger
                            },
                            title: "Call BSH Service",
                            prefixIcon: Icon(
                              Icons.phone_in_talk_outlined,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // "THEY'LL ASK FOR THIS" Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "THEY'LL ASK FOR THIS",
                            style: AppTextStyles.medium2.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _infoRow('Model', model, context),
                          _infoRow('Serial', serial, context),
                          _infoRow('Bought', purchaseDate, context),
                          SizedBox(height: 14.h),

                          // Copy All Three Action
                          GestureDetector(
                            onTap: () => _copyDetailsToClipboard(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAEBF4),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.copy_outlined,
                                    size: 16.sp,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryFixed,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Copy all three',
                                    style: AppTextStyles.small.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryFixed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Notification Info Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notifications_none_outlined,
                          size: 20.sp,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "We'll check back in three days to make sure it actually got sorted. If it didn't, we'll step in.",
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // Bottom Floating Done Action Button
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: PrimaryButton(
                onTap: () => Navigator.of(context).maybePop(),
                title: 'Done',
                bg: Theme.of(context).colorScheme.onPrimary,
                textcolor: Theme.of(context).colorScheme.onPrimaryFixed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.small.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.small.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
