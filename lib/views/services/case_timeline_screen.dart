import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

enum CaseStepStatus { done, current, future }

class CaseStep {
  final String title;
  final String? subtitle;
  final CaseStepStatus status;

  const CaseStep({required this.title, this.subtitle, required this.status});
}

class CaseTimelineScreen extends StatelessWidget {
  final String caseNumber;
  final String title;
  final String coverageTitle;
  final String coverageSubtitle;
  final String technicianName;
  final String technicianRole;
  final String technicianEta;
  final String infoMessage;
  final List<CaseStep> steps;
  final VoidCallback? onCoverIncludesPressed;

  const CaseTimelineScreen({
    super.key,
    this.caseNumber = '24-10583',
    this.title = "We're handling this",
    this.coverageTitle = 'Covered by your extended protection',
    this.coverageSubtitle = 'No call-out fee, no parts cost and no excess.',
    this.technicianName = 'Amir Cohen',
    this.technicianRole = 'technician',
    this.technicianEta = 'Arriving today between 14:00 and 16:00',
    this.infoMessage =
        "Every step is written by the technician's own app as it happens — no need to ring anyone to ask where he is.",
    this.steps = const [
      CaseStep(
        title: 'Case received',
        subtitle: 'Today 09:12',
        status: CaseStepStatus.done,
      ),
      CaseStep(
        title: 'Technician assigned',
        subtitle: 'Today 09:40',
        status: CaseStepStatus.done,
      ),
      CaseStep(
        title: 'On the way',
        subtitle: 'Arriving about 14:20',
        status: CaseStepStatus.current,
      ),
      CaseStep(
        title: 'Job closed',
        subtitle: 'Pending',
        status: CaseStepStatus.future,
      ),
    ],
    this.onCoverIncludesPressed,
  });

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

                    // Top Kicker Case Reference
                    Text(
                      'CASE $caseNumber'.toUpperCase(),
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Main Title
                    Text(
                      title,
                      style: AppTextStyles.semiBold.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Extended Protection Hero Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,

                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coverageTitle,
                            style: AppTextStyles.semiBold.copyWith(
                              fontSize: 15.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            coverageSubtitle,
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Technician Details Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          // Custom Avatar Container
                          Container(
                            width: 52.w,
                            height: 52.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9DCF0),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                AppAssets.profile,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$technicianName · $technicianRole',
                                  style: AppTextStyles.semiBold.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  technicianEta,
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
                    ),
                    SizedBox(height: 16.h),

                    // Progress Section Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PROGRESS',
                            style: AppTextStyles.medium2.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: steps.length,
                            itemBuilder: (context, index) {
                              final doneIndex = steps
                                  .take(index)
                                  .where((s) => s.status == CaseStepStatus.done)
                                  .length;
                              return _TimelineRow(
                                step: steps[index],
                                isLast: index == steps.length - 1,
                                doneIndex: doneIndex,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Real-time info row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.flash_on_outlined,
                          size: 20.sp,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            infoMessage,
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

            // Bottom Action Pill Button
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: PrimaryButton(
                onTap: onCoverIncludesPressed ?? () {},
                title: 'What my cover includes',
                bg: Theme.of(context).colorScheme.onPrimary,
                textcolor: Theme.of(context).colorScheme.onPrimaryFixed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final CaseStep step;
  final bool isLast;
  final int doneIndex;

  const _TimelineRow({
    required this.step,
    required this.isLast,
    required this.doneIndex,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> doneColors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.onPrimaryFixed,
      Theme.of(context).colorScheme.inversePrimary,
      Theme.of(context).colorScheme.onSecondary,
    ];
    Color currentColor = Theme.of(context).colorScheme.inversePrimary; // blue
    const Color futureColor = Color(0xFFD3D6E4); // gray

    final bool isFuture = step.status == CaseStepStatus.future;
    final bool isCurrent = step.status == CaseStepStatus.current;

    final Color nodeColor = isFuture
        ? futureColor
        : isCurrent
        ? currentColor
        : doneColors[doneIndex % doneColors.length];

    final Color titleColor = isFuture ? const Color(0xFF8A94A6) : nodeColor;
    final Color subtitleColor = Theme.of(context).colorScheme.onSecondary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Dot Indicator + Line
          SizedBox(
            width: 28.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Alignment offset so circle center matches title text baseline center
                SizedBox(height: 2.h),

                // Dot / Node with Halo
                SizedBox(
                  width: 28.sp,
                  height: 28.sp,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isCurrent)
                        Container(
                          width: 28.sp,
                          height: 28.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: .20),
                          ),
                        ),
                      Container(
                        width: 16.sp,
                        height: 16.sp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFuture ? Colors.white : nodeColor,
                          border: Border.all(
                            color: nodeColor,
                            width: isFuture ? 2 : 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Connector Line
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: const Color(0xFFE2E4EE)),
                  ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Right Side: Content (Title & Subtitle)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 15.sp,
                      color: titleColor,
                    ),
                  ),
                  if (step.subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      step.subtitle!,
                      style: AppTextStyles.small.copyWith(
                        fontSize: 12.sp,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
