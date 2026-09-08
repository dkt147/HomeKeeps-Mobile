import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class ExtendedCoverScreen extends StatefulWidget {
  final int daysLeft;
  final String brandName;
  final VoidCallback? onBackTap;
  final Function(int years, int monthlyPrice, int totalPrice)? onContinueTap;

  const ExtendedCoverScreen({
    super.key,
    this.daysLeft = 46,
    this.brandName = 'Bosch',
    this.onBackTap,
    this.onContinueTap,
  });

  @override
  State<ExtendedCoverScreen> createState() => _ExtendedCoverScreenState();
}

class _ExtendedCoverScreenState extends State<ExtendedCoverScreen> {
  // Option index: 0 = 2 years, 1 = 3 years, 2 = 5 years
  int _selectedIndex = 1;

  final List<Map<String, dynamic>> _durationOptions = [
    {'years': 2, 'monthlyPrice': 22, 'totalPrice': 528, 'badge': null},
    {
      'years': 3,
      'monthlyPrice': 19,
      'totalPrice': 690,
      'badge': 'MOST TAKE THIS',
    },
    {'years': 5, 'monthlyPrice': 17, 'totalPrice': 1020, 'badge': null},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedOption = _durationOptions[_selectedIndex];
    final years = selectedOption['years'] as int;
    final monthlyPrice = selectedOption['monthlyPrice'] as int;
    final totalPrice = selectedOption['totalPrice'] as int;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: GestureDetector(
                  onTap:
                      widget.onBackTap ??
                      () => Navigator.of(context).maybePop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 18.sp,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Back',
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 15.sp,

                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Header Section with Appliance Illustration Placeholder
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.daysLeft} DAYS OF COVER LEFT'
                                .toUpperCase(),
                            style: AppTextStyles.medium2.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Keep it\ncovered\nwhen ${widget.brandName}\nstops',
                            style: AppTextStyles.semiBold.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Image.asset(AppAssets.diswasher),
                ],
              ),
              SizedBox(height: 28.h),

              // WHAT'S COVERED Card
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WHAT'S COVERED",
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    10.verticalSpace,
                    _infoCard(
                      items: const [
                        'Anything mechanical or electrical that breaks',
                        'Call-out, labour and parts — all of it',
                        'As many visits as it takes',
                        'A replacement if it can\'t be fixed',
                      ],
                      icon: Icons.check_circle_outline,
                      iconColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                    20.verticalSpace,
                    Text(
                      "WHAT'S NOT",
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    10.verticalSpace,
                    _infoCard(
                      items: const [
                        'Damage, misuse, scratches and dents',
                        'Anything already wrong with it today',
                        'Filters, seals and hoses',
                        'Anything used for business',
                      ],
                      icon: Icons.cancel_outlined,
                      iconColor: const Color(0xFF9099CF),
                    ),
                    SizedBox(height: 14.h),

                    // Transparency Notice Text
                    Text(
                      'Deliberately in front of the price. It\'s what stops arguments after the first call-out.',
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // HOW LONG FOR Selector Header
                    Text(
                      'HOW LONG FOR',
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Duration Selection Cards
                    Row(
                      children: List.generate(_durationOptions.length, (index) {
                        final option = _durationOptions[index];
                        final isSelected = _selectedIndex == index;
                        final hasBadge = option['badge'] != null;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: index == _durationOptions.length - 1
                                    ? 0
                                    : 10.w,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                      horizontal: 8.w,
                                    ),
                                    // margin: EdgeInsets.only(
                                    //   top: hasBadge ? 8.h : 0,
                                    // ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : Color(0xff292C47),
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: Column(
                                      children: [
                                        if (hasBadge) SizedBox(height: 4.h),
                                        Text(
                                          '${option['years']} years',
                                          style: AppTextStyles.semiBold
                                              .copyWith(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected
                                                    ? Theme.of(context)
                                                          .colorScheme
                                                          .onPrimaryFixed
                                                    : Theme.of(
                                                        context,
                                                      ).colorScheme.onSecondary,
                                              ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          '${option['monthlyPrice']}',
                                          style: AppTextStyles.semiBold
                                              .copyWith(
                                                fontWeight: FontWeight.w900,
                                                color: isSelected
                                                    ? Theme.of(
                                                        context,
                                                      ).colorScheme.primary
                                                    : Theme.of(
                                                        context,
                                                      ).colorScheme.onPrimary,
                                              ),
                                        ),
                                        Text(
                                          'ILS a month',
                                          style: AppTextStyles.small.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (hasBadge)
                                    Positioned(
                                      top: -8,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 3.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.inversePrimary,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        child: Text(
                                          option['badge'],
                                          style: AppTextStyles.medium2.copyWith(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w800,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16.h),

                    // Detailed Summary Breakdown Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Color(0xff292C47),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        children: [
                          _summaryRow('Cover starts', '13 Oct 2026'),
                          _summaryRow('First 30 days', 'Waiting period'),
                          _summaryRow('You pay per repair', 'ILS 0'),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Divider(
                              color: Theme.of(context).colorScheme.onSecondary,
                              height: 1,
                            ),
                          ),
                          _summaryRow(
                            'Total for $years years',
                            'ILS $totalPrice',
                            isBold: true,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                'Read the full terms',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 13.sp,

                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.open_in_new,
                                size: 14.sp,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Price Guarantee Lock Note
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 18.sp,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'The terms you buy today are the terms you keep — frozen into your contract, whatever we change later.',
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Bottom Floating CTA Action Button
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                child: PrimaryButton(
                  onTap: () {
                    if (widget.onContinueTap != null) {
                      widget.onContinueTap!(years, monthlyPrice, totalPrice);
                    }
                  },
                  title: 'Continue · ILS $totalPrice for $years years',
                  bg: Theme.of(context).colorScheme.onPrimary,
                  textcolor: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
              // 15.verticalSpace,
              Center(
                child: Text(
                  'Maybe later',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 15.sp,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  // Card Builder for Covered/Not Covered Lists
  Widget _infoCard({
    required List<String> items,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Color(0xff292C47),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Icon(icon, size: 18.sp, color: iconColor),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Row Builder for Financial Summary Breakdown
  Widget _summaryRow(String label, String value, {bool isBold = false}) {
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
            style: AppTextStyles.semiBold.copyWith(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
