import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class ReadReceiptScreen extends StatefulWidget {
  final VoidCallback? onRetakeTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onTypeInsteadTap;

  const ReadReceiptScreen({
    super.key,
    this.onRetakeTap,
    this.onSaveTap,
    this.onTypeInsteadTap,
  });

  @override
  State<ReadReceiptScreen> createState() => _ReadReceiptScreenState();
}

class _ReadReceiptScreenState extends State<ReadReceiptScreen> {
  final _storeController = TextEditingController(
    text: 'Electra Home, Rishon LeZion',
  );
  final _dateController = TextEditingController(text: '12 Oct 2024');
  final _priceController = TextEditingController(text: 'ILS 2,790');
  final _serialController = TextEditingController();

  @override
  void dispose() {
    _storeController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // Top Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back / Retake Navigation Link
                    GestureDetector(
                      onTap:
                          widget.onRetakeTap ??
                          () => Navigator.of(context).maybePop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 16.sp,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Retake',
                            style: AppTextStyles.semiBold.copyWith(
                              fontSize: 15.sp,

                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryFixed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Header Section with Document Preview Thumbnail
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Document Preview Thumbnail Icon Card
                        Container(
                          width: 68.w,
                          height: 80.h,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Image.asset(AppAssets.receipt, scale: 3.0),
                          ),
                        ),
                        SizedBox(width: 16.w),

                        // Title and Description Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Here's what\nwe read",
                                style: AppTextStyles.semiBold.copyWith(
                                  height: 1.1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Tap anything to correct it. We keep your original either way.',
                                style: AppTextStyles.small.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // 1. Store Field (Full Width Tile)
                    _readDataTile(
                      label: 'Store',
                      badgeText: 'READ',
                      controller: _storeController,
                    ),
                    SizedBox(height: 12.h),

                    // 2. Date & Price Grid Row
                    Row(
                      children: [
                        Expanded(
                          child: _readDataTile(
                            label: 'Date',
                            badgeText: 'READ',
                            controller: _dateController,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _readDataTile(
                            label: 'Price',
                            badgeText: 'READ',
                            controller: _priceController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // 3. Appliance Matched Tile with Graphic Thumbnail
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/images/q-washer.png", scale: 3.0),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Appliance',
                                      style: AppTextStyles.medium2.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    _statusBadge('MATCHED'),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                RichText(
                                  text: TextSpan(
                                    style: AppTextStyles.small.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Bosch dishwasher ',
                                        style: AppTextStyles.semiBold.copyWith(
                                          fontSize: 15.sp,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'SMV4HVX00E',
                                        style: AppTextStyles.semiBold.copyWith(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // 4. Missing Serial Number Input Card with Outline Border
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFF333B76).withOpacity(0.2),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Serial number',
                                  style: AppTextStyles.medium2.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                TextField(
                                  controller: _serialController,
                                  style: AppTextStyles.small.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    hintText:
                                        "Couldn't find it on the receipt — add it?",
                                    hintStyle: AppTextStyles.small.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.add_circle_outline,
                            size: 20.sp,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // 5. Original Photo Vault Info Note Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,

                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.system_update_alt_outlined,
                            size: 20.sp,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Your original photo goes into the vault under this appliance, whatever you change here.',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom Fixed Actions
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
              child: Column(
                children: [
                  // Main CTA Save Button
                  PrimaryButton(
                    onTap: widget.onSaveTap ?? () {},
                    title: "That's right — save it",
                  ),
                  SizedBox(height: 12.h),

                  // Alternative Secondary Action
                  GestureDetector(
                    onTap: widget.onTypeInsteadTap ?? () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Text(
                        'Let me type it instead',
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 15.sp,

                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Single Editable Data Field Tile
  Widget _readDataTile({
    required String label,
    required String badgeText,
    required TextEditingController controller,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(width: 6.w),
              _statusBadge(badgeText),
            ],
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: controller,
            style: AppTextStyles.semiBold.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  // Small Pill Badge Indicator Widget
  Widget _statusBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.inversePrimary.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: AppTextStyles.buttonLabel.copyWith(
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.inversePrimary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
