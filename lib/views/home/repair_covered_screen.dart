import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/models/service_case_detail_model.dart';
import 'package:home_keeps/models/service_case_model.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class RepairCoveredScreen extends StatefulWidget {
  final String caseId;

  const RepairCoveredScreen({super.key, required this.caseId});

  @override
  State<RepairCoveredScreen> createState() => _RepairCoveredScreenState();
}

class _RepairCoveredScreenState extends State<RepairCoveredScreen> {
  late final ProductController productController;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    productController.getServiceCase(caseId: widget.caseId);
  }

  String _formatDate(String? iso) {
    if (iso == null) return '-';
    final d = DateTime.tryParse(iso);
    if (d == null) return '-';
    return '${d.day} ${_months[d.month - 1]} ${d.year}';
  }

  String _shortRef(String? id) {
    if (id == null || id.isEmpty) return '-';
    return (id.length > 8 ? id.substring(0, 8) : id).toUpperCase();
  }

  void _copyDetailsToClipboard(
    BuildContext context, {
    required String model,
    required String serial,
    required String purchaseDate,
  }) {
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
        child: GetBuilder<ProductController>(
          builder: (controller) {
            if (controller.isCaseLoading) {
              return _buildSkeleton();
            }

            final serviceCase = controller.serviceCase;
            if (controller.caseError || serviceCase == null) {
              return _buildError();
            }

            return _buildContent(serviceCase);
          },
        ),
      ),
    );
  }

  // ---------------- Loading / Error ----------------
  Widget _buildSkeleton() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          AppSkeleton(width: 120.w, height: 12.h),
          SizedBox(height: 10.h),
          AppSkeleton(width: 200.w, height: 26.h),
          SizedBox(height: 8.h),
          AppSkeleton(width: 140.w, height: 26.h),
          SizedBox(height: 20.h),
          AppSkeleton(width: double.infinity, height: 130.h, radius: 24),
          SizedBox(height: 16.h),
          AppSkeleton(width: double.infinity, height: 170.h, radius: 24),
          SizedBox(height: 16.h),
          AppSkeleton(width: double.infinity, height: 190.h, radius: 24),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Couldn't load your case",
              style: AppTextStyles.semiBold.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(onPressed: _load, child: const Text('Try again')),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Main content ----------------
  Widget _buildContent(ServiceCaseModel serviceCase) {
    final detail = productController.productDetailModel?.data;
    final product = (detail != null && detail.id == serviceCase.productId)
        ? detail
        : null;

    final manufacturer = product?.manufacturer?.name ?? 'The manufacturer';
    final providerName = '$manufacturer support';
    final providerPhone = product?.manufacturer?.supportPhone ?? '-';
    final model = product?.model ?? '-';
    final serial = product?.serialNumber ?? '-';
    final purchaseDate = _formatDate(product?.purchaseDate);
    final caseReference = _shortRef(serviceCase.id);

    final isManufacturer = serviceCase.coverageSource == 'MANUFACTURER';
    final isFree = (serviceCase.chargedToCustomer ?? 0) == 0;

    final title = isFree
        ? '$manufacturer will\nfix this, free'
        : '$manufacturer will\nhandle this';
    final bannerHeadline = isManufacturer
        ? "Still under the maker's\nwarranty"
        : 'Your cover\napplies';
    final bannerBody = isFree
        ? 'Their own engineers handle it. Nothing to pay — not the call-out, not the parts.'
        : 'Your cover applies to this repair. Ask them what you need to pay.';

    return Column(
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
                  title,
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
                              bannerHeadline,
                              style: AppTextStyles.semiBold.copyWith(
                                fontSize: 16.sp,
                                color: Theme.of(context).colorScheme.onPrimary,
                                height: 1.25,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              bannerBody,
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

                      // Appliance Graphic
                      Image.asset("assets/images/q-dishwasher.png", scale: 1.7),
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
                        providerPhone,
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
                        title: 'Call $manufacturer support',
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
                      _infoRow('Model', model),
                      _infoRow('Serial', serial),
                      _infoRow('Bought', purchaseDate),
                      SizedBox(height: 14.h),

                      // Copy All Three Action
                      GestureDetector(
                        onTap: () => _copyDetailsToClipboard(
                          context,
                          model: model,
                          serial: serial,
                          purchaseDate: purchaseDate,
                        ),
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

        // Bottom Done Button
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
          child: PrimaryButton(
            onTap: () => Get.close(3),
            title: 'Done',
            bg: Theme.of(context).colorScheme.onPrimary,
            textcolor: Theme.of(context).colorScheme.onPrimaryFixed,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
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
