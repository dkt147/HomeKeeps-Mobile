import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/services/case_timeline_screen.dart';
import 'package:home_keeps/widgets/wallet_component.dart';

class ServiceCasesScreen extends StatefulWidget {
  const ServiceCasesScreen({super.key});

  @override
  State<ServiceCasesScreen> createState() => _ServiceCasesScreenState();
}

class _ServiceCasesScreenState extends State<ServiceCasesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              Text(
                'my_service'.tr,
                style: AppTextStyles.semiBold.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'open'.tr,
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 10.h),

              // Open case card — surface fill
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => CaseTimelineScreen(
                      caseNumber: '#4471',
                      // applianceName: 'Bosch dishwasher',
                      // issueTitle: "Water isn't draining",
                      // chipStatus: WalletChipStatus.technicianScheduled,
                      steps: [
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
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        size: 27.sp,
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                      SizedBox(width: 13.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Water isn't draining",
                              style: AppTextStyles.semiBold.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Bosch dishwasher . case #4471',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // Row(
                            //   children: [
                            //     const StatusChip(
                            //       status: WalletChipStatus.technicianScheduled,
                            //     ),
                            //     SizedBox(width: 8.w),
                            //     Text(
                            //       'Thursday 14:00',
                            //       style: AppTextStyles.metaCaption.copyWith(
                            //         color: Theme.of(
                            //           context,
                            //         ).colorScheme.onPrimaryFixed,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 18.sp,
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              Text(
                'closed'.tr,
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 6.h),
              _buildServiceCard(
                ontap: () {},
                title: 'Loud noise while spinning',
                value: 'LG washung machine . closed 03.02.2026',
              ),
              _buildServiceCard(
                ontap: () {},
                title: "Door seal replaced",
                value: "Bosch dishwasher . closed 18.06.2026",
              ),
              _buildServiceCard(
                ontap: () {},
                title: "Not cooling properly",
                value: "Samsung refrigerator . closed 22.11.2024",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required VoidCallback ontap,
    required String title,
    required String value,
  }) {
    return GestureDetector(
      onTap: ontap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.semiBold.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: AppTextStyles.small.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18.sp,
              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),
          ],
        ),
      ),
    );
  }
}
