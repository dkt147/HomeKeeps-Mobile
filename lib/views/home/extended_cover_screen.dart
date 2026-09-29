import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/navigation_controller.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/data/response/status.dart';
import 'package:home_keeps/models/offers_model.dart';
import 'package:home_keeps/repository/check_out_repo.dart';
import 'package:home_keeps/utils/utils.dart';
import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';
import 'package:home_keeps/widgets/web_view_screen.dart';

class ExtendedCoverScreen extends StatefulWidget {
  final String id;

  const ExtendedCoverScreen({super.key, required this.id});

  @override
  State<ExtendedCoverScreen> createState() => _ExtendedCoverScreenState();
}

class _ExtendedCoverScreenState extends State<ExtendedCoverScreen> {
  late final ProductController productController;
  final CheckoutRepo checkoutRepo = CheckoutRepo();

  bool _termsAccepted = false;
  bool _isCheckingOut = false;
  bool _initialized = false;
  int _selectedIndex = 0;
  Offer? _selectedOffer;

  static const Color _cardColor = Color(0xff292C47);

  @override
  void initState() {
    super.initState();

    try {
      productController = Get.find<ProductController>();
    } catch (e) {
      productController = Get.put(ProductController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Future.wait([
          Future.sync(() => productController.getProductDetail(id: widget.id)),
          Future.sync(() => productController.getOffers(productId: widget.id)),
        ]);
      } catch (e) {
        debugPrint('ExtendedCoverScreen load error: $e');
      } finally {
        if (mounted) setState(() => _initialized = true);
      }
    });
  }

  double _priceInMajor(Offer? offer) {
    if (offer == null) return 0;
    final num raw = offer.price ?? 0;
    return raw / 100;
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  int _monthsOf(Offer? offer) => offer?.durationMonths ?? 0;

  String _durationLabel(int months) {
    if (months > 0 && months % 12 == 0) {
      final y = months ~/ 12;
      return '$y year${y == 1 ? '' : 's'}';
    }
    return '$months month${months == 1 ? '' : 's'}';
  }

  Future<void> _onCheckout() async {
    final offer = _selectedOffer;
    if (offer == null || !_termsAccepted || _isCheckingOut) return;

    final planId = offer.planId ?? offer.id;
    if (planId == null) {
      Utils.errorBar("This plan can't be checked out right now.");
      return;
    }

    setState(() => _isCheckingOut = true);

    try {
      final result = await checkoutRepo.checkoutOffer(
        planId: planId,
        productId: widget.id,
      );

      final data = result["data"];
      final redirectUrl = data?["payment_session"]?["redirect_url"];

      if (!mounted) return;

      if (redirectUrl != null && redirectUrl.toString().isNotEmpty) {
        Get.to(
          () => InAppWebViewScreen(
            gameUrl: redirectUrl.toString(),
            gameTitle: "Card Authentication",
            forcePortrait: true,
            enableWebViewHistory: false,
            onExit: () {
              final navigationController = Get.find<NavigationController>();
              navigationController.selectIndex(0);
              Get.offAll(
                () => const NavigatorScreen(),
                transition: Transition.rightToLeft,
              );
            },
          ),
        );
      } else {
        Utils.errorBar(result["message"] ?? 'Please try again.');
      }
    } catch (e) {
      Utils.errorBar(e.toString());
    } finally {
      if (mounted) setState(() => _isCheckingOut = false);
    }
  }

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: GetBuilder<ProductController>(
          builder: (controller) {
            if (controller.apiResponse.status == Status.loading) {
              return _buildSkeleton();
            }

            // ✅ Saara data GetBuilder ke andar, taake update() par fresh ho
            final rawOffersData = controller.offersModel?.data;
            final isStaleData =
                rawOffersData != null && rawOffersData.productId != widget.id;
            final offersData = isStaleData ? null : rawOffersData;
            final List<Offer> offers = offersData?.offers ?? <Offer>[];
            final hasOffers = offers.isNotEmpty;

            final effectiveSelectedIndex = _selectedIndex < offers.length
                ? _selectedIndex
                : 0;
            final Offer? selectedOffer = hasOffers
                ? offers[effectiveSelectedIndex]
                : null;
            _selectedOffer = selectedOffer;

            final months = _monthsOf(selectedOffer);
            final totalPrice = _priceInMajor(selectedOffer);
            final currency = selectedOffer?.currency ?? 'ILS';
            final durationText = _durationLabel(months);

            final showOffersSkeleton =
                !_initialized || controller.isOffersLoading || isStaleData;

            final data = controller.productDetailModel?.data;
            final warranty = data?.warranty;
            final isCovered = warranty?.status == 'covered';
            final daysLeft = warranty?.daysRemaining ?? 0;
            final brandName = data?.manufacturer?.name ?? '';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
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

                  // Header
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
                                    : 'NOT CURRENTLY COVERED',
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
                        _buildWarrantyMessage(warranty),
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

                        // Offers area
                        if (showOffersSkeleton)
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
                              color: _cardColor,
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
                              final isSelected =
                                  effectiveSelectedIndex == index;
                              final offerMonths = _monthsOf(offer);
                              final offerTotal = _priceInMajor(offer);
                              final perMonth = offerMonths > 0
                                  ? (offerTotal / offerMonths).round()
                                  : 0;

                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _selectedIndex = index);
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
                                          : _cardColor,
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          _durationLabel(offerMonths),
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
                                        // Text(
                                        //   '$perMonth',
                                        //   style: AppTextStyles.semiBold
                                        //       .copyWith(
                                        //         fontWeight: FontWeight.w900,
                                        //         color: isSelected
                                        //             ? Theme.of(
                                        //                 context,
                                        //               ).colorScheme.primary
                                        //             : Theme.of(
                                        //                 context,
                                        //               ).colorScheme.onPrimary,
                                        //       ),
                                        // ),
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

                        // Summary card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(18.w),
                          decoration: BoxDecoration(
                            color: _cardColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            children: [
                              _summaryRow(
                                'Duration',
                                selectedOffer != null ? '$months months' : '-',
                              ),
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
                                selectedOffer != null
                                    ? 'Total for $durationText'
                                    : 'Total',
                                selectedOffer != null
                                    ? '$currency ${_fmt(totalPrice)}'
                                    : '-',
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

                  // Terms + Continue sirf tab jab offers hon
                  if (!showOffersSkeleton && hasOffers) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Checkbox(
                              value: _termsAccepted,
                              onChanged: (value) {
                                setState(() => _termsAccepted = value ?? false);
                              },
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                              checkColor: Colors.blue,
                              fillColor: WidgetStateProperty.all<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(
                                () => _termsAccepted = !_termsAccepted,
                              ),
                              child: Text(
                                'Terms accepted',
                                style: AppTextStyles.small.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                      child: Builder(
                        builder: (context) {
                          final isDisabled =
                              selectedOffer == null ||
                              !_termsAccepted ||
                              _isCheckingOut;

                          return PrimaryButton(
                            onTap: isDisabled ? null : _onCheckout,
                            title: _isCheckingOut
                                ? 'Please wait…'
                                : 'Continue · $currency ${_fmt(totalPrice)} for $durationText',
                            bg: isDisabled
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimary.withOpacity(0.35)
                                : Theme.of(context).colorScheme.onPrimary,
                            textcolor: isDisabled
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryFixed.withOpacity(0.6)
                                : Theme.of(context).colorScheme.onPrimaryFixed,
                          );
                        },
                      ),
                    ),
                  ],
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Text(
                        'Maybe later',
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 15.sp,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
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

  // ---------- Widgets ----------

  Widget _buildWarrantyMessage(dynamic warranty) {
    final status = warranty?.status;
    final message = warranty?.message;

    if (message == null || message.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    if (status == 'covered') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WHAT'S COVERED",
            style: AppTextStyles.medium2.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          10.verticalSpace,
          _messageCard(
            message: message.toString(),
            icon: Icons.check_circle_outline,
            iconColor: Theme.of(context).colorScheme.onSecondary,
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
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          10.verticalSpace,
          _messageCard(
            message: message.toString(),
            icon: Icons.cancel_outlined,
            iconColor: const Color(0xFF9099CF),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSkeleton() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: AppSkeleton(width: 70.w, height: 18.h),
          ),
          SizedBox(height: 20.h),
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
                AppSkeleton(width: 130.w, height: 12.h),
                10.verticalSpace,
                AppSkeleton(width: double.infinity, height: 70.h, radius: 20),
                SizedBox(height: 24.h),
                AppSkeleton(width: 120.w, height: 12.h),
                SizedBox(height: 12.h),
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
                AppSkeleton(width: double.infinity, height: 160.h, radius: 20),
                SizedBox(height: 18.h),
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

  Widget _messageCard({
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: _cardColor,
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
              fontWeight: isBold ? FontWeight.w800 : null,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
