import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/data/response/status.dart';
import 'package:home_keeps/views/home/edit_appliance_screen.dart';
import 'package:home_keeps/views/home/extended_cover_screen.dart';
import 'package:home_keeps/views/home/fault_options_screen.dart';

import 'package:home_keeps/widgets/primary_button.dart';
import 'package:intl/intl.dart';

class ServiceHistoryItem {
  final String title;
  final String closedDate;
  final String caseNumber;

  const ServiceHistoryItem({
    required this.title,
    required this.closedDate,
    required this.caseNumber,
  });
}

class ApplianceDetailScreen extends StatefulWidget {
  final String id;

  const ApplianceDetailScreen({super.key, required this.id});

  @override
  State<ApplianceDetailScreen> createState() => _ApplianceDetailScreenState();
}

class _ApplianceDetailScreenState extends State<ApplianceDetailScreen> {
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
    });
  }

  bool _remindMe = true;

  Widget _sectionKicker(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h, top: 16.h),
      child: Text(
        label,
        style: AppTextStyles.medium2.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }

  Widget _labelValueRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
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

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: child,
    );
  }

  void _showDeleteDialog({
    required String title,
    required String message,
    required String confirmText,
    required Future<bool> Function() onConfirm,
  }) {
    bool isLoading = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return PopScope(
            canPop: !isLoading,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                title: Text(
                  title,
                  style: AppTextStyles.dialogTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                content: Text(
                  message,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() => isLoading = true);

                            final success = await onConfirm();

                            if (success) {
                              Get.back(); // dialog band
                              Get.back(); // detail screen band, list par wapas
                            } else {
                              setState(() => isLoading = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            confirmText,
                            style: AppTextStyles.buttonLabel.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onInverseSurface,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GetBuilder<ProductController>(
        builder: (controller) {
          if (controller.apiResponse.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF1B2050)),
            );
          }
          final healthScore =
              productController.productDetailModel?.data?.healthScore
                  ?.toDouble() ??
              0.0;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image Header with Actions
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 400.h,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: const Color(0xFFD8DCED),
                        image: DecorationImage(
                          image: AssetImage(AppAssets.kitchen),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.5),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black87,
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                ),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(
                                        0.6,
                                      ),
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                    ),
                                    onPressed: () {
                                      final data = productController
                                          .productDetailModel
                                          ?.data;

                                      Get.to(
                                        () => EditApplianceScreen(
                                          productId: data?.id ?? widget.id,
                                          initialModel: data?.model ?? '',
                                          initialSerial:
                                              data?.serialNumber ?? '',
                                          initialPurchaseDate:
                                              DateTime.tryParse(
                                                data?.purchase?.date ?? '',
                                              ) ??
                                              DateTime.now(),
                                          hasActiveExtendedWarranty: true,
                                        ),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    child: Text(
                                      'Edit',
                                      style: AppTextStyles.small.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  CircleAvatar(
                                    backgroundColor: Colors.white.withOpacity(
                                      0.5,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Place asset illustration image here if available
                    ),

                    Positioned(
                      left: 16.w,
                      right: 16.w,
                      bottom: -100.h,
                      child: _buildCardContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productController
                                      .productDetailModel
                                      ?.data
                                      ?.name ??
                                  "",
                              style: AppTextStyles.semiBold.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              productController
                                      .productDetailModel
                                      ?.data
                                      ?.model ??
                                  "",
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: (healthScore / 100).clamp(0.0, 1.0),
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF5A4FE0),
                                ),
                                minHeight: 6.h,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${productController.productDetailModel?.data?.warranty?.daysRemaining ?? ''} days left of maker\'s warranty · ends ${formatDate(productController.productDetailModel?.data?.warranty?.endDate)}',
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
                  ],
                ),

                // Main Content Area
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100.h),
                      PrimaryButton(
                        bg: Theme.of(context).colorScheme.inversePrimary,

                        onTap: () {
                          final data =
                              productController.productDetailModel?.data;
                          if (data?.categoryId == null) return;

                          final productId = data!.id ?? widget.id;

                          Get.to(
                            () => FaultOptionsScreen(
                              productId: productId,
                              applianceName: data.name ?? '',
                              categoryId: data.categoryId!,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        prefixIcon: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                        ),
                        title: "Something's wrong with it",
                      ),

                      // PURCHASE
                      _sectionKicker('PURCHASE'),
                      _buildCardContainer(
                        child: Column(
                          children: [
                            _labelValueRow(
                              'Bought',
                              formatDate(
                                productController
                                    .productDetailModel
                                    ?.data
                                    ?.purchase
                                    ?.date,
                              ),
                            ),
                            _labelValueRow(
                              'Store',
                              productController
                                      .productDetailModel
                                      ?.data
                                      ?.store ??
                                  '-',
                            ),
                            _labelValueRow(
                              'Price',
                              productController
                                      .productDetailModel
                                      ?.data
                                      ?.purchase
                                      ?.price
                                      .toString() ??
                                  '-',
                            ),
                            _labelValueRow(
                              'Serial',
                              productController
                                      .productDetailModel
                                      ?.data
                                      ?.serialNumber ??
                                  '',
                            ),
                          ],
                        ),
                      ),

                      // DOCUMENTS
                      _sectionKicker('DOCUMENTS'),
                      _buildCardContainer(
                        child: Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Receipt',
                                    style: AppTextStyles.semiBold.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    'PDF · added 12 Oct 2026',
                                    style: AppTextStyles.small.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_red_eye_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.share_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildCardContainer(
                        child: Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Warranty certificate',
                                    style: AppTextStyles.semiBold.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    'Not here yet — add it when you have a moment',
                                    style: AppTextStyles.small.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Add',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 15.sp,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // WARRANTY
                      _sectionKicker('WARRANTY'),
                      _buildCardContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productController
                                      .productDetailModel
                                      ?.data
                                      ?.warranty
                                      ?.message ??
                                  '',
                              style: AppTextStyles.semiBold.copyWith(
                                fontSize: 16.sp,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Call-out, parts and labour are included for faults the warranty covers. After that date there is no cover unless you extend.',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            PrimaryButton(
                              bg: Theme.of(context).scaffoldBackgroundColor,
                              textcolor: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                Get.to(
                                  () => ExtendedCoverScreen(),
                                  transition: Transition.rightToLeft,
                                );
                                // Get.to(
                                //   () => ExtendedWarrantyOfferScreen(
                                //     applianceName: widget.applianceName,
                                //     headline:
                                //         'Three more years of repairs, after initial warranty ends',
                                //     price: '₪690',
                                //     priceNote: 'once · covers 36 months',
                                //     covered: const [
                                //       'Mechanical and electrical breakdown',
                                //       'Technician call-out, labour and parts',
                                //       'Unlimited number of visits',
                                //       "Replacement if it can't be repaired",
                                //     ],
                                //     notCovered: const [
                                //       'Accidental damage, misuse and cosmetic wear',
                                //       'Faults that already exist today',
                                //       'Consumables: filters, seals, hoses',
                                //       'Commercial or business use',
                                //     ],
                                //     coverBegins: widget.warrantyEndDate,
                                //     waitingPeriod: '30 days from purchase',
                                //     yourSharePerClaim: '₪0',
                                //     claimLimit: '₪2,790',
                                //     term: '36 months',
                                //   ),
                                //   transition: Transition.rightToLeft,
                                // );
                              },
                              title: 'Extend the protection',
                              width: 220.w,
                            ),
                          ],
                        ),
                      ),

                      // SERVICE HISTORY
                      _sectionKicker('SERVICE HISTORY'),
                      _buildCardContainer(
                        child: Column(
                          children: List.generate(
                            productController
                                    .productDetailModel
                                    ?.data
                                    ?.serviceHistory
                                    ?.length ??
                                0,
                            (index) {
                              final item = productController
                                  .productDetailModel!
                                  .data!
                                  .serviceHistory![index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.description ?? '',
                                                style: AppTextStyles.semiBold
                                                    .copyWith(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                    ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                'Status ${item.status ?? ''}',
                                                style: AppTextStyles.small
                                                    .copyWith(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.onSecondary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      // SETTINGS
                      _sectionKicker('SETTINGS'),
                      _buildCardContainer(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Remind me before the warranty ends',
                                    style: AppTextStyles.semiBold.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                SwitchTheme(
                                  data: SwitchThemeData(
                                    thumbColor: WidgetStateProperty.all(
                                      Theme.of(context).colorScheme.onPrimary,
                                    ),
                                    trackOutlineColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    trackOutlineWidth: WidgetStateProperty.all(
                                      0,
                                    ),
                                    thumbIcon: WidgetStateProperty.all(
                                      const Icon(
                                        Icons.circle,
                                        size: 16,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),

                                  child: Switch(
                                    value: controller.warrantyReminderEnabled,

                                    activeTrackColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    inactiveTrackColor: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                    onChanged: (val) {
                                      controller.updateWarrantyReminder(
                                        id: widget.id,
                                        enabled: val,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            InkWell(
                              onTap: () {
                                _showDeleteDialog(
                                  title: 'Remove this appliance?',
                                  message:
                                      'It will be removed from your appliances. This can\'t be undone from the app.',
                                  confirmText: 'Remove',
                                  onConfirm: () => productController
                                      .deleteProduct(id: widget.id),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Remove this appliance',
                                      style: AppTextStyles.small.copyWith(
                                        // fontSize: 14.sp,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.inversePrimary,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
}
