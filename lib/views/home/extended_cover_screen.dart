import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/data/response/status.dart';
import 'package:home_keeps/models/offers_model.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';
import 'package:intl/intl.dart';

class ExtendedCoverScreen extends StatefulWidget {
  final String id;

  const ExtendedCoverScreen({super.key, required this.id});

  @override
  State<ExtendedCoverScreen> createState() => _ExtendedCoverScreenState();
}

class _ExtendedCoverScreenState extends State<ExtendedCoverScreen> {
  late final ProductController productController;

  @override
  void initState() {
    super.initState();

    try {
      productController = Get.find<ProductController>();
    } catch (e) {
      productController = Get.put(ProductController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.getProductDetail(id: widget.id);
      productController.getOffers(productId: widget.id);
    });
  }

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
    // final years = selectedOption['years'] as int;
    // final monthlyPrice = selectedOption['monthlyPrice'] as int;
    // final totalPrice = selectedOption['totalPrice'] as int;
    final offersData = productController.offersModel?.data;
    final offers = offersData?.offers ?? [];
    final hasOffers = offersData?.isAvailable ?? false;

    final Offer? selectedOffer = hasOffers && _selectedIndex < offers.length
        ? offers[_selectedIndex]
        : null;
    final years = selectedOffer?.years ?? 0;
    final monthlyPrice = selectedOffer?.monthlyPrice.round() ?? 0;
    final totalPrice = selectedOffer?.priceInCurrency.round() ?? 0;
    final currency = selectedOffer?.currency ?? 'ILS';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: GetBuilder<ProductController>(
          builder: (controller) {
            if (controller.apiResponse.status == Status.loading) {
              return _buildSkeleton();
            }

            final data = controller.productDetailModel?.data;
            final warranty = data?.warranty;
            final isCovered = warranty?.status == 'covered';
            final daysLeft = warranty?.daysRemaining ?? 0;
            final brandName = data?.manufacturer?.name ?? '';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
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
                                isCovered
                                    ? '$daysLeft DAYS OF COVER LEFT'
                                          .toUpperCase()
                                    : 'NOT CURRENTLY COVERED'.toUpperCase(),
                                style: AppTextStyles.medium2.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                isCovered
                                    ? 'Keep it\ncovered\nwhen $brandName\nstops'
                                    : 'Get it\ncovered\nbefore $brandName\nbreaks',
                                style: AppTextStyles.semiBold.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
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

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            final status = warranty?.status;
                            final message = warranty?.message;

                            if (message == null || message.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            if (status == 'covered') {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "WHAT'S COVERED",
                                    style: AppTextStyles.medium2.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  _messageCard(
                                    message: message,
                                    icon: Icons.check_circle_outline,
                                    iconColor: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ],
                              );
                            }

                            if (status == 'uncovered') {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "WHAT'S NOT",
                                    style: AppTextStyles.medium2.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  _messageCard(
                                    message: message,
                                    icon: Icons.cancel_outlined,
                                    iconColor: const Color(0xFF9099CF),
                                  ),
                                ],
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          'Deliberately in front of the price. It\'s what stops arguments after the first call-out.',
                          style: AppTextStyles.small.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'HOW LONG FOR',
                          style: AppTextStyles.medium2.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (controller.isOffersLoading)
                          Row(
                            children: List.generate(
                              2,
                              (i) => Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: i == 1 ? 0 : 10.w,
                                  ),
                                  child: AppSkeleton(
                                    width: double.infinity,
                                    height: 90.h,
                                    radius: 18,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else if (!hasOffers)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(18.w),
                            decoration: BoxDecoration(
                              color: Color(0xff292C47),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              offersData?.serviceFirst?.message ??
                                  'No extended cover plans are available for this appliance right now.',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                          )
                        else
                          Row(
                            children: List.generate(offers.length, (index) {
                              final offer = offers[index];
                              final isSelected = _selectedIndex == index;

                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: index == offers.length - 1
                                          ? 0
                                          : 10.w,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                      horizontal: 8.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : Color(0xff292C47),
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${offer.years} year${offer.years == 1 ? '' : 's'}',
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
                                          '${offer.monthlyPrice.round()}',
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
                                          '${offer.currency ?? 'ILS'} a month',
                                          style: AppTextStyles.small.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
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
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(18.w),
                          decoration: BoxDecoration(
                            color: Color(0xff292C47),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            children: [
                              _summaryRow(
                                'Cover starts',
                                formatDate(warranty?.startDate).isEmpty
                                    ? '-'
                                    : formatDate(warranty?.startDate),
                              ),
                              _summaryRow('First 30 days', 'Waiting period'),
                              _summaryRow('You pay per repair', 'ILS 0'),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                    child: PrimaryButton(
                      onTap: selectedOffer == null
                          ? null
                          : () {
                              // if (widget.onContinueTap != null) {
                              //   widget.onContinueTap!(years, monthlyPrice, totalPrice);
                              // }
                            },
                      title: selectedOffer == null
                          ? 'No plans available'
                          : 'Continue · $currency $totalPrice for $years years',
                      bg: Theme.of(context).colorScheme.onPrimary,
                      textcolor: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                  ),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back row placeholder
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: AppSkeleton(width: 70.w, height: 18.h),
          ),
          SizedBox(height: 20.h),

          // Header + illustration placeholder
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
                      AppSkeleton(width: 160.w, height: 12.h),
                      SizedBox(height: 10.h),
                      AppSkeleton(width: 200.w, height: 22.h),
                      SizedBox(height: 6.h),
                      AppSkeleton(width: 170.w, height: 22.h),
                      SizedBox(height: 6.h),
                      AppSkeleton(width: 190.w, height: 22.h),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: AppSkeleton(width: 90.w, height: 90.h, radius: 16),
              ),
            ],
          ),
          SizedBox(height: 28.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // WHAT'S COVERED / NOT card placeholder
                AppSkeleton(width: 130.w, height: 12.h),
                10.verticalSpace,
                AppSkeleton(width: double.infinity, height: 70.h, radius: 20),
                SizedBox(height: 24.h),

                // HOW LONG FOR label
                AppSkeleton(width: 120.w, height: 12.h),
                SizedBox(height: 12.h),

                // Duration cards row
                Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: index == 2 ? 0 : 10.w),
                        child: AppSkeleton(
                          width: double.infinity,
                          height: 90.h,
                          radius: 18,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16.h),

                // Summary card placeholder
                AppSkeleton(width: double.infinity, height: 160.h, radius: 20),
                SizedBox(height: 18.h),

                // Lock note placeholder
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeleton(width: 18.w, height: 18.h, radius: 4),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSkeleton(width: double.infinity, height: 12.h),
                          SizedBox(height: 6.h),
                          AppSkeleton(width: 200.w, height: 12.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // CTA button placeholder
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
            child: AppSkeleton(
              width: double.infinity,
              height: 56.h,
              radius: 28,
            ),
          ),
          Center(
            child: AppSkeleton(width: 90.w, height: 14.h),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  Widget _messageCard({
    required String message,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: iconColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
