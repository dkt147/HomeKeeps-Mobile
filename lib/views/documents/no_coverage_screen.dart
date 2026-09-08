import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';
import 'package:home_keeps/widgets/wallet_component.dart';

class NoCoverageScreen extends StatelessWidget {
  final String applianceName; // "LG washing machine"
  final String warrantyEndDate; // "18.05.2026"
  final String visitPrice; // "₪349"
  final VoidCallback? onBookVisit;
  final VoidCallback? onDecline;

  const NoCoverageScreen({
    super.key,
    required this.applianceName,
    required this.warrantyEndDate,
    required this.visitPrice,
    this.onBookVisit,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onPrimaryFixed;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusChip(status: WalletChipStatus.noCoverage),
              SizedBox(height: 16.h),

              Text(
                "This repair isn't covered",
                style: AppTextStyles.screenTitle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),

              RichText(
                text: TextSpan(
                  style: AppTextStyles.body.copyWith(color: hintColor),
                  children: [
                    const TextSpan(text: 'The manufacturer warranty on your '),
                    TextSpan(
                      text: applianceName,
                      style: TextStyle(color: hintColor),
                    ),
                    const TextSpan(text: ' ended on '),
                    TextSpan(
                      text: warrantyEndDate,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' and there is no extended warranty on it. We '
                          'can still send someone — as a paid visit.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Paid visit card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PAID TECHNICIAN VISIT',
                      style: AppTextStyles.kicker.copyWith(color: hintColor),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          visitPrice,
                          style: AppTextStyles.priceLarge.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'including VAT',
                          style: AppTextStyles.metaCaption.copyWith(
                            color: hintColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    _bulletRow(
                      context,
                      Icons.check,
                      theme.colorScheme.primary,
                      'Call-out and diagnosis',
                      theme.colorScheme.onSurface,
                    ),
                    _bulletRow(
                      context,
                      Icons.check,
                      theme.colorScheme.primary,
                      'Up to one hour of labour',
                      theme.colorScheme.onSurface,
                    ),
                    _bulletRow(
                      context,
                      Icons.close,
                      hintColor,
                      'Parts quoted separately, with your approval first',
                      hintColor,
                      isLast: true,
                    ),

                    SizedBox(height: 18.h),
                    PrimaryButton(
                      onTap: onBookVisit ?? () {},
                      title: 'Book the visit for $visitPrice',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Quiet, honest way out
              Center(
                child: GestureDetector(
                  onTap: onDecline,
                  child: Text(
                    "No thanks, I'll leave it",
                    style: AppTextStyles.body.copyWith(color: hintColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bulletRow(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String text,
    Color textColor, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: iconColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
