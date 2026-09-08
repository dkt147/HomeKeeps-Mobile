import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/services/case_timeline_screen.dart';
import 'package:home_keeps/widgets/app_form_field.dart';
import 'package:home_keeps/widgets/primary_button.dart';
import 'package:home_keeps/widgets/wallet_component.dart';

class TimeSlot {
  final String day;
  final String time; // "08:00–11:00"

  const TimeSlot(this.day, this.time);
}

class ScheduleVisitScreen extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final String address;
  final List<TimeSlot> availableSlots;

  const ScheduleVisitScreen({
    super.key,
    this.currentStep = 3,
    this.totalSteps = 3,
    required this.address,
    this.availableSlots = const [
      TimeSlot('Sunday', '08:00–11:00'),
      TimeSlot('Monday', '14:00–17:00'),
      TimeSlot('Wednesday', '11:00–14:00'),
      TimeSlot('Thursday', '08:00–11:00'),
    ],
  });

  @override
  State<ScheduleVisitScreen> createState() => _ScheduleVisitScreenState();
}

class _ScheduleVisitScreenState extends State<ScheduleVisitScreen> {
  static const _maxSlots = 3;
  static const _ordinals = ['1st', '2nd', '3rd'];

  final _notesController = TextEditingController();
  final List<TimeSlot> _selected = [];

  @override
  void initState() {
    super.initState();
    // Pre-select the first three, matching the screenshot's starting state.
    _selected.addAll(widget.availableSlots.take(_maxSlots));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleSlot(TimeSlot slot) {
    setState(() {
      if (_selected.contains(slot)) {
        _selected.remove(slot);
      } else if (_selected.length < _maxSlots) {
        _selected.add(slot);
      }
    });
  }

  bool get _canSubmit => _selected.length == _maxSlots;

  void _submit() {
    debugPrint(
      'Address: ${widget.address}, notes: ${_notesController.text}, '
      'slots: ${_selected.map((s) => '${s.day} ${s.time}').join(', ')}',
    );
    Get.to(
      () => CaseTimelineScreen(
        caseNumber: '#4471',
        // applianceName: 'Bosch dishwasher',
        // issueTitle: "Water isn't draining",
        // chipStatus: WalletChipStatus.technicianScheduled,
        steps: [
          CaseStep(
            title: 'Request received',
            subtitle: '24.08.2026 · 09:12',
            status: CaseStepStatus.done,
          ),
          CaseStep(
            title: 'Coverage confirmed',
            subtitle: '24.08.2026 · 09:12 · covered by your extended warranty',
            status: CaseStepStatus.done,
          ),
          CaseStep(
            title: 'Technician assigned',
            subtitle: '25.08.2026 · 11:40 · Amir from Kav Service',
            status: CaseStepStatus.done,
          ),
          CaseStep(
            title: 'Visit on Thursday, 14:00–17:00',
            subtitle: "You'll get a text when he's on the way",
            status: CaseStepStatus.current,
          ),
          CaseStep(title: 'Repair complete', status: CaseStepStatus.future),
        ],
      ),
      transition: Transition.rightToLeft,
    );
  }

  Widget _stepRail(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= widget.totalSteps; i++) ...[
          Container(
            width: 34.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: i <= widget.currentStep
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          if (i != widget.totalSteps) SizedBox(width: 5.w),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + step rail
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 16.sp,
                          color: theme.colorScheme.secondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Back',
                          style: AppTextStyles.buttonLabel.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _stepRail(theme),
                ],
              ),
              SizedBox(height: 16.h),

              // Coverage badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.secondaryContainer, // --color-accent100
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Text(
                  'Covered by your extended warranty',
                  style: AppTextStyles.chipLabel.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                "We'll send a technician",
                style: AppTextStyles.screenTitle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                'No charge for the visit, the labour or covered parts. '
                'Tell us where and when suits you.',
                style: AppTextStyles.body.copyWith(color: hintColor),
              ),
              SizedBox(height: 24.h),

              // ADDRESS
              AppFormField(
                label: 'ADDRESS',
                hint: 'Your address',
                displayValue: widget.address,
                trailing: Icon(
                  Icons.location_on_outlined,
                  size: 18.sp,
                  color: hintColor,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _notesController,
                  style: AppTextStyles.fieldValue.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Entry code, floor, parking notes...',
                    hintStyle: AppTextStyles.fieldValue.copyWith(
                      color: hintColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'PICK THREE WINDOWS THAT WORK',
                style: AppTextStyles.kicker.copyWith(color: hintColor),
              ),
              SizedBox(height: 15.h),

              for (final slot in widget.availableSlots)
                _SlotRow(
                  slot: slot,
                  isSelected: _selected.contains(slot),
                  ordinalLabel: _selected.contains(slot)
                      ? _ordinals[_selected.indexOf(slot)]
                      : null,
                  isDisabled:
                      !_selected.contains(slot) &&
                      _selected.length >= _maxSlots,
                  onTap: () => _toggleSlot(slot),
                ),

              SizedBox(height: 12.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16.sp,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'We confirm a slot within one business day and text '
                      'you the technician\'s name.',
                      style: AppTextStyles.metaCaption.copyWith(
                        color: hintColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              Opacity(
                opacity: _canSubmit ? 1 : 0.45,
                child: PrimaryButton(
                  onTap: _canSubmit ? _submit : null,
                  title: 'Send my request',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlotRow extends StatelessWidget {
  final TimeSlot slot;
  final bool isSelected;
  final bool isDisabled;
  final String? ordinalLabel;
  final VoidCallback onTap;

  const _SlotRow({
    required this.slot,
    required this.isSelected,
    required this.isDisabled,
    required this.ordinalLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onPrimaryFixed;

    return Opacity(
      opacity: isDisabled ? 0.45 : 1,
      child: IgnorePointer(
        ignoring: isDisabled,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme
                        .colorScheme
                        .primaryContainer // --color-accent100
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(2.r),
              border: isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.primary : hintColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(2.r), // never round
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 14.sp,
                          color: theme.colorScheme.onPrimary,
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    '${slot.day} · ${slot.time}',
                    style: AppTextStyles.body.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (ordinalLabel != null)
                  Text(
                    ordinalLabel!,
                    style: AppTextStyles.chipLabel.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
