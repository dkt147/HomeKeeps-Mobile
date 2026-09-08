import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/payment/payment_screen.dart';

import 'package:home_keeps/widgets/primary_button.dart';

class ExtendedWarrantyOfferScreen extends StatefulWidget {
  final String applianceName; // "Bosch dishwasher"
  final String
  headline; // "Three more years of repairs, after Bosch stops covering it"
  final String price; // "₪690"
  final String priceNote; // "once · covers 36 months"
  final List<String> covered;
  final List<String> notCovered;
  final String coverBegins;
  final String waitingPeriod;
  final String yourSharePerClaim;
  final String claimLimit;
  final String term;

  const ExtendedWarrantyOfferScreen({
    super.key,
    required this.applianceName,
    required this.headline,
    required this.price,
    required this.priceNote,
    required this.covered,
    required this.notCovered,
    required this.coverBegins,
    required this.waitingPeriod,
    required this.yourSharePerClaim,
    required this.claimLimit,
    required this.term,
  });

  @override
  State<ExtendedWarrantyOfferScreen> createState() =>
      _ExtendedWarrantyOfferScreenState();
}

class _ExtendedWarrantyOfferScreenState
    extends State<ExtendedWarrantyOfferScreen> {
  bool _hasReadTerms = false;

  Widget _termsRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.listItemTitle.copyWith(
              color: theme.colorScheme.onSurface, // --color-accent700
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 120.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),

          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 16.sp,
                  color: theme.colorScheme.secondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Back',
                  style: AppTextStyles.buttonLabel.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.applianceName.toUpperCase(),
                style: AppTextStyles.kicker.copyWith(color: hintColor),
              ),
              SizedBox(height: 10.h),

              Text(
                widget.headline,
                style: AppTextStyles.screenTitle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16.h),

              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    widget.price,
                    style: AppTextStyles.priceLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    widget.priceNote,
                    style: AppTextStyles.metaCaption.copyWith(color: hintColor),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              // WHAT IS COVERED
              Text(
                'WHAT IS COVERED',
                style: AppTextStyles.kicker.copyWith(color: hintColor),
              ),
              SizedBox(height: 10.h),
              for (final item in widget.covered)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: theme.colorScheme.secondaryContainer,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 13.sp,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.body.copyWith(
                            color: theme
                                .colorScheme
                                .onSurface, // --color-accent700
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 18.h),

              // WHAT IS NOT COVERED
              Text(
                'WHAT IS NOT COVERED',
                style: AppTextStyles.kicker.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              SizedBox(height: 10.h),
              for (final item in widget.notCovered)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: theme.colorScheme.errorContainer,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 17.sp,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.body.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 24.h),

              // THE TERMS IN NUMBERS
              Text(
                'THE TERMS IN NUMBERS',
                style: AppTextStyles.kicker.copyWith(color: hintColor),
              ),
              SizedBox(height: 4.h),
              _termsRow(context, 'Cover begins', widget.coverBegins),
              _termsRow(context, 'Waiting period', widget.waitingPeriod),
              _termsRow(
                context,
                'Your share per claim',
                widget.yourSharePerClaim,
              ),
              _termsRow(context, 'Claim limit', widget.claimLimit),
              _termsRow(context, 'Term', widget.term),
              SizedBox(height: 10.h),

              GestureDetector(
                onTap: () {
                  // TODO: open full terms document
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Read the full terms',
                      style: AppTextStyles.buttonLabel.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.open_in_new,
                      size: 14.sp,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Consent checkbox
              GestureDetector(
                onTap: () => setState(() => _hasReadTerms = !_hasReadTerms),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.w,
                      margin: EdgeInsets.only(top: 2.h),
                      decoration: BoxDecoration(
                        color: _hasReadTerms
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: _hasReadTerms
                              ? theme.colorScheme.primary
                              : hintColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      child: _hasReadTerms
                          ? Icon(
                              Icons.check,
                              size: 14.sp,
                              color: theme.colorScheme.onPrimary,
                            )
                          : null,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'I have read the coverage, the exclusions and the '
                        'full terms.',
                        style: AppTextStyles.body.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              Opacity(
                opacity: _hasReadTerms ? 1 : 0.45,
                child: PrimaryButton(
                  onTap: _hasReadTerms
                      ? () {
                          Get.to(
                            () => PaymentScreen(),
                            transition: Transition.rightToLeft,
                          );
                        }
                      : null,
                  title: 'Continue to payment',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
