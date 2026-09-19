import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/models/service_case_detail_model.dart';
import 'package:home_keeps/models/service_case_model.dart';
import 'package:home_keeps/views/services/case_timeline_screen.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/wallet_component.dart';

class ServiceCasesScreen extends StatefulWidget {
  const ServiceCasesScreen({super.key});

  @override
  State<ServiceCasesScreen> createState() => _ServiceCasesScreenState();
}

class _ServiceCasesScreenState extends State<ServiceCasesScreen> {
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

  Future<void> _load({bool silent = false}) {
    return productController.getServiceCases(silent: silent);
  }

  // ---------------- Helpers ----------------

  // not_starting -> Not starting
  String _pretty(String? value) {
    if (value == null || value.isEmpty) return '';
    final s = value.replaceAll('_', ' ');
    return s[0].toUpperCase() + s.substring(1);
  }

  // Lambi UUID ki jagah pehle 8 characters
  String _shortRef(String? id) {
    if (id == null || id.isEmpty) return '-';
    return (id.length > 8 ? id.substring(0, 8) : id).toUpperCase();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  // 10 Sep, 22:35
  String _fmtDateTime(String? iso) {
    final d = DateTime.tryParse(iso ?? '')?.toLocal();
    if (d == null) return '-';
    return '${d.day} ${_months[d.month - 1]}, ${_two(d.hour)}:${_two(d.minute)}';
  }

  // 03.02.2026
  String _fmtDotDate(String? iso) {
    final d = DateTime.tryParse(iso ?? '')?.toLocal();
    if (d == null) return '-';
    return '${_two(d.day)}.${_two(d.month)}.${d.year}';
  }

  String _titleOf(ServiceCaseModel c) {
    final desc = c.description?.trim() ?? '';
    return desc.isNotEmpty ? desc : _pretty(c.faultType);
  }

  IconData _iconFor(String? faultType) {
    switch (faultType) {
      case 'water_leak':
      case 'drainage_problem':
        return Icons.water_drop_outlined;
      case 'not_heating':
        return Icons.local_fire_department_outlined;
      case 'electrical_fault':
        return Icons.bolt_outlined;
      case 'not_spinning':
        return Icons.sync;
      case 'not_starting':
        return Icons.power_settings_new;
      default:
        return Icons.build_outlined;
    }
  }

  List<CaseStep> _buildSteps(ServiceCaseModel c) {
    final closed = c.isClosed;
    final reached = closed
        ? 4
        : (c.scheduledAt != null ? 3 : (c.technicianName != null ? 2 : 1));

    CaseStepStatus statusOf(int i) {
      if (i < reached) return CaseStepStatus.done;
      if (i == reached) return CaseStepStatus.current;
      return CaseStepStatus.future;
    }

    return [
      CaseStep(
        title: 'Case received',
        subtitle: _fmtDateTime(c.createdAt),
        status: statusOf(0),
      ),
      CaseStep(
        title: 'Technician assigned',
        subtitle: c.technicianName ?? 'Pending',
        status: statusOf(1),
      ),
      CaseStep(
        title: 'Visit scheduled',
        subtitle: c.scheduledAt != null
            ? _fmtDateTime(c.scheduledAt)
            : 'Pending',
        status: statusOf(2),
      ),
      CaseStep(
        title: 'Job closed',
        subtitle: closed ? _fmtDateTime(c.closedAt) : 'Pending',
        status: statusOf(3),
      ),
    ];
  }

  void _openTimeline(ServiceCaseModel c) {
    if (c.id == null) return;

    Get.to(
      () => CaseTimelineScreen(caseId: c.id!),
      transition: Transition.rightToLeft,
    );
  }

  // ---------------- Build ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _load(silent: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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

                GetBuilder<ProductController>(
                  builder: (controller) {
                    if (controller.isServiceCasesLoading) {
                      return _buildSkeleton();
                    }

                    if (controller.serviceCasesError) {
                      return _buildError();
                    }

                    final open = controller.serviceCases
                        .where((c) => !c.isClosed)
                        .toList();
                    final closed = controller.serviceCases
                        .where((c) => c.isClosed)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('open'.tr),
                        SizedBox(height: 10.h),
                        if (open.isEmpty)
                          _emptyText('No open cases')
                        else
                          for (final item in open)
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildOpenCard(item),
                            ),

                        SizedBox(height: 16.h),

                        _sectionLabel('closed'.tr),
                        SizedBox(height: 6.h),
                        if (closed.isEmpty)
                          _emptyText('No closed cases')
                        else
                          for (final item in closed)
                            _buildServiceCard(
                              ontap: () => _openTimeline(item),
                              title: _titleOf(item),
                              value:
                                  'case #${_shortRef(item.id)} . closed ${_fmtDotDate(item.closedAt ?? item.updatedAt)}',
                            ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.medium2.copyWith(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  Widget _emptyText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        text,
        style: AppTextStyles.small.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }

  // ---------------- Loading / Error ----------------

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('open'.tr),
        SizedBox(height: 10.h),
        AppSkeleton(width: double.infinity, height: 84.h, radius: 24),
        SizedBox(height: 44.h),
        _sectionLabel('closed'.tr),
        SizedBox(height: 6.h),
        for (int i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSkeleton(width: 190.w, height: 16.h),
                      SizedBox(height: 6.h),
                      AppSkeleton(width: 240.w, height: 12.h),
                    ],
                  ),
                ),
                AppSkeleton(width: 18.w, height: 18.w),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          children: [
            Text(
              "Couldn't load your cases",
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            TextButton(onPressed: _load, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }

  // ---------------- Cards ----------------

  Widget _buildOpenCard(ServiceCaseModel item) {
    final scheduled = item.scheduledAt != null
        ? ' · ${_fmtDateTime(item.scheduledAt)}'
        : '';

    return GestureDetector(
      onTap: () => _openTimeline(item),
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
              _iconFor(item.faultType),
              size: 27.sp,
              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleOf(item),
                    style: AppTextStyles.semiBold.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'case #${_shortRef(item.id)}',
                    style: AppTextStyles.small.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${_pretty(item.status)}$scheduled',
                    style: AppTextStyles.small.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
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
