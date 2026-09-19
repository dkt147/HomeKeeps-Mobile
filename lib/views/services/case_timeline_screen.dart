import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/models/service_case_detail_model.dart';
import 'package:home_keeps/models/service_case_model.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';

enum CaseStepStatus { done, current, future }

class CaseStep {
  final String title;
  final String? subtitle;
  final CaseStepStatus status;

  const CaseStep({required this.title, this.subtitle, required this.status});
}

class CaseTimelineScreen extends StatefulWidget {
  final String caseId;
  final VoidCallback? onCoverIncludesPressed;

  const CaseTimelineScreen({
    super.key,
    required this.caseId,
    this.onCoverIncludesPressed,
  });

  @override
  State<CaseTimelineScreen> createState() => _CaseTimelineScreenState();
}

class _CaseTimelineScreenState extends State<CaseTimelineScreen> {
  late final ProductController productController;

  // Pehle frame par purana (kisi aur case ka) data na dikhe
  bool _started = false;

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

  static const _infoMessage =
      "Every step is written by the technician's own app as it happens — no need to ring anyone to ask where he is.";

  @override
  void initState() {
    super.initState();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
      if (mounted) setState(() => _started = true);
    });
  }

  void _load() {
    productController.getServiceCase(caseId: widget.caseId);
  }

  // ---------------- Helpers ----------------

  String _two(int n) => n.toString().padLeft(2, '0');

  // 10 Sep, 22:35
  String _fmtDateTime(String? iso) {
    final d = DateTime.tryParse(iso ?? '')?.toLocal();
    if (d == null) return '-';
    return '${d.day} ${_months[d.month - 1]}, ${_two(d.hour)}:${_two(d.minute)}';
  }

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

  // Status ke naam ka text. Apne hisaab se badal sakte hain.
  String _stepTitle(String? status) {
    switch (status) {
      case 'new':
        return 'Case received';
      case 'routed':
        return 'Sent to the service team';
      case 'scheduled':
        return 'Visit scheduled';
      case 'closed':
        return 'Job closed';
      default:
        return _pretty(status);
    }
  }

  // API ki timeline se steps: case_opened aur status_changed events
  List<CaseStep> _buildSteps(ServiceCaseModel c) {
    final events =
        c.timeline
            .where((e) => e.type == 'case_opened' || e.type == 'status_changed')
            .toList()
          ..sort((a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''));

    // [title, subtitle]
    final raw = <List<String>>[];

    for (final e in events) {
      if (e.type == 'case_opened') {
        raw.add(['Case received', _fmtDateTime(e.createdAt)]);
      } else {
        final to = e.toStatus;
        final subtitle = (to == 'scheduled' && c.scheduledAt != null)
            ? 'Visit ${_fmtDateTime(c.scheduledAt)}'
            : _fmtDateTime(e.createdAt);
        raw.add([_stepTitle(to), subtitle]);
      }
    }

    if (raw.isEmpty) {
      raw.add(['Case received', _fmtDateTime(c.createdAt)]);
    }

    final closed = c.isClosed;

    if (closed && raw.last[0] != 'Job closed') {
      raw.add(['Job closed', _fmtDateTime(c.closedAt)]);
    }

    final steps = <CaseStep>[];
    for (var i = 0; i < raw.length; i++) {
      final isLastEvent = i == raw.length - 1;
      steps.add(
        CaseStep(
          title: raw[i][0],
          subtitle: raw[i][1],
          status: (!closed && isLastEvent)
              ? CaseStepStatus.current
              : CaseStepStatus.done,
        ),
      );
    }

    if (!closed) {
      steps.add(
        const CaseStep(
          title: 'Job closed',
          subtitle: 'Pending',
          status: CaseStepStatus.future,
        ),
      );
    }

    return steps;
  }

  // ---------------- Build ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: GetBuilder<ProductController>(
          builder: (controller) {
            if (!_started || controller.isCaseLoading) {
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
          AppSkeleton(width: 220.w, height: 26.h),
          SizedBox(height: 20.h),
          AppSkeleton(width: double.infinity, height: 90.h, radius: 24),
          SizedBox(height: 16.h),
          AppSkeleton(width: double.infinity, height: 84.h, radius: 24),
          SizedBox(height: 16.h),
          AppSkeleton(width: double.infinity, height: 260.h, radius: 24),
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
              "Couldn't load this case",
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

  Widget _buildContent(ServiceCaseModel serviceCase) {
    final closed = serviceCase.isClosed;
    final isFree = (serviceCase.chargedToCustomer ?? 0) == 0;
    final isManufacturer = serviceCase.coverageSource == 'MANUFACTURER';

    final title = closed ? 'This case is closed' : "We're handling this";

    final coverageTitle = isManufacturer
        ? "Covered by the maker's warranty"
        : 'Covered by your extended protection';
    final coverageSubtitle = isFree
        ? 'No call-out fee, no parts cost and no excess.'
        : 'Some costs may apply to this repair.';

    final hasTechnician = (serviceCase.technicianName ?? '').isNotEmpty;
    final technicianTitle = hasTechnician
        ? '${serviceCase.technicianName} · technician'
        : 'Waiting for a technician';
    final technicianSubtitle = closed
        ? 'Closed ${_fmtDateTime(serviceCase.closedAt)}'
        : hasTechnician
        ? (serviceCase.scheduledAt != null
              ? 'Visit scheduled for ${_fmtDateTime(serviceCase.scheduledAt)}'
              : "We'll confirm the visit time soon")
        : "We'll update this once one is assigned.";

    final steps = _buildSteps(serviceCase);

    return Column(
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
                  'CASE ${_shortRef(serviceCase.id)}'.toUpperCase(),
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

                // Coverage Hero Card
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
                              technicianTitle,
                              style: AppTextStyles.semiBold.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              technicianSubtitle,
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
                        _infoMessage,
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
            onTap: widget.onCoverIncludesPressed ?? () {},
            title: 'What my cover includes',
            bg: Theme.of(context).colorScheme.onPrimary,
            textcolor: Theme.of(context).colorScheme.onPrimaryFixed,
          ),
        ),
      ],
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
