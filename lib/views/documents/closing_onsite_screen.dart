import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class ClosingOnSiteScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onSubmitTap;

  const ClosingOnSiteScreen({super.key, this.onBackTap, this.onSubmitTap});

  @override
  State<ClosingOnSiteScreen> createState() => _ClosingOnSiteScreenState();
}

class _ClosingOnSiteScreenState extends State<ClosingOnSiteScreen> {
  String _selectedOutcome = 'Fixed it';
  final TextEditingController _notesController = TextEditingController(
    text: 'Drain pump was blocked. Cleared it and tested two cycles.',
  );

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Link Header
                    GestureDetector(
                      onTap:
                          widget.onBackTap ??
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
                            'Job card',
                            style: AppTextStyles.semiBold.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryFixed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Title Section
                    Text(
                      'CASE 24-10583',
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Closing on site',
                      style: AppTextStyles.semiBold.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'All four sections are needed before this can be submitted.',
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // SECTION 1: WHAT HAPPENED
                    _sectionHeader('1 · WHAT HAPPENED', isCompleted: true),
                    SizedBox(height: 8.h),

                    // Selected Option Card (Fixed it)
                    _selectableCard(
                      label: 'Fixed it',
                      isSelected: _selectedOutcome == 'Fixed it',
                      onTap: () =>
                          setState(() => _selectedOutcome = 'Fixed it'),
                    ),
                    SizedBox(height: 8.h),

                    // Grid Row Options (Needs parts / Nothing wrong)
                    Row(
                      children: [
                        Expanded(
                          child: _selectableCard(
                            label: 'Needs parts',
                            isSelected: _selectedOutcome == 'Needs parts',
                            onTap: () => setState(
                              () => _selectedOutcome = 'Needs parts',
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _selectableCard(
                            label: 'Nothing wrong',
                            isSelected: _selectedOutcome == 'Nothing wrong',
                            onTap: () => setState(
                              () => _selectedOutcome = 'Nothing wrong',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Notes Text Field Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 3,

                        style: AppTextStyles.small.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        decoration: InputDecoration(
                          hintStyle: AppTextStyles.small.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // SECTION 2: PARTS AND TIME
                    _sectionHeader('2 · PARTS AND TIME', isCompleted: true),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Drain pump seal kit',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 15.sp,

                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                'ILS 84',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 15.sp,

                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Add a part pill button
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFEFE8F6,
                              ).withValues(alpha: .60),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 14.sp,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryFixed,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Add a part',
                                  style: AppTextStyles.semiBold.copyWith(
                                    fontSize: 13.sp,

                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Divider(
                            color: const Color(0xFFF1F0F8),
                            height: 1.h,
                            thickness: 1.h,
                          ),
                          SizedBox(height: 14.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Time on site',
                                style: AppTextStyles.small.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                '50 minutes',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 15.sp,

                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'These two numbers are what let us price protection properly from next year.',
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // SECTION 3: PHOTOS
                    _sectionHeader('3 · PHOTOS', isCompleted: true),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Before',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 13.sp,

                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              _photoBox(hasWater: true),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'After',
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 13.sp,

                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              _photoBox(hasWater: false),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // SECTION 4: CUSTOMER SIGNATURE
                    _sectionHeader(
                      '4 · CUSTOMER SIGNATURE',
                      isCompleted: false,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 84.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Center(
                        child: Text(
                          'Ask Dana to sign here',
                          style: AppTextStyles.small.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom Actions & Offline Banner
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: Column(
                children: [
                  // Offline Status Box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 18.sp,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'No signal? Submit anyway — it\'s saved on the phone and sent the moment you\'re back online.',
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Submit and close Button
                  PrimaryButton(
                    onTap: widget.onSubmitTap ?? () {},
                    title: 'Submit and close',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Header Widget with Checkmark Indicator
  Widget _sectionHeader(String title, {required bool isCompleted}) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.medium2.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
            letterSpacing: 0.8,
          ),
        ),
        if (isCompleted) ...[
          SizedBox(width: 6.w),
          Icon(
            Icons.check_circle_outline,
            size: 14.sp,
            color: Theme.of(context).colorScheme.onPrimaryFixed,
          ),
        ],
      ],
    );
  }

  // Radio Tile Option Card
  Widget _selectableCard({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryFixed
                : Colors.transparent,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryFixed
                      : Theme.of(context).colorScheme.onSecondary,
                  width: isSelected ? 6.5 : 1.8,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 14.sp,

                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Photo Container Graphic Placeholder
  Widget _photoBox({required bool hasWater}) {
    return Container(
      height: 80.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1738),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.grid_on_rounded,
              size: 32.sp,
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          if (hasWater)
            Container(
              height: 22.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF4370AC).withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
            )
          else
            Positioned(
              bottom: 8.h,
              child: Container(
                width: 32.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF4370AC).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
