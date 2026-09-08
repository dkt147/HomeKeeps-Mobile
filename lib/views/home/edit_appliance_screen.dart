import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class EditApplianceScreen extends StatefulWidget {
  final String initialModel;
  final String initialSerial;
  final DateTime initialPurchaseDate;
  final bool hasActiveExtendedWarranty;

  const EditApplianceScreen({
    super.key,
    required this.initialModel,
    required this.initialSerial,
    required this.initialPurchaseDate,
    this.hasActiveExtendedWarranty = false,
  });

  @override
  State<EditApplianceScreen> createState() => _EditApplianceScreenState();
}

class _EditApplianceScreenState extends State<EditApplianceScreen> {
  late final _modelController = TextEditingController(
    text: widget.initialModel,
  );
  late final _serialController = TextEditingController(
    text: widget.initialSerial,
  );
  late DateTime _purchaseDate = widget.initialPurchaseDate;

  @override
  void dispose() {
    _modelController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  String get _formattedDate =>
      '${_purchaseDate.day.toString().padLeft(2, '0')}.'
      '${_purchaseDate.month.toString().padLeft(2, '0')}.'
      '${_purchaseDate.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  void _saveChanges() {
    debugPrint(
      'Model: ${_modelController.text}, '
      'Serial: ${_serialController.text}, '
      'Purchase date: $_formattedDate',
    );
    Navigator.of(context).maybePop();
  }

  Widget _fieldLabel(String label) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: AppTextStyles.medium2.copyWith(
        color: theme.colorScheme.onSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cancel
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.close,
                      size: 16.sp,
                      color: theme.colorScheme.onPrimaryFixed,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Cancel',
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 15.sp,
                        // fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimaryFixed,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                'Edit appliance details',
                style: AppTextStyles.semiBold.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 24.h),

              // MODEL
              _fieldLabel('MODEL'),
              SizedBox(height: 8.h),
              Container(
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _modelController,
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

              // SERIAL NUMBER
              _fieldLabel('SERIAL NUMBER'),
              SizedBox(height: 8.h),
              Container(
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _serialController,
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

              // PURCHASE DATE
              _fieldLabel('PURCHASE DATE'),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formattedDate,
                          style: AppTextStyles.small.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18.sp,
                        color: theme.colorScheme.onPrimaryFixed,
                      ),
                    ],
                  ),
                ),
              ),

              // Review note — only shown when it's actually relevant
              if (widget.hasActiveExtendedWarranty) ...[
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16.sp,
                      color: theme.colorScheme.onPrimaryFixed,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.small.copyWith(
                            color: theme.colorScheme.onSecondary,
                          ),
                          children: [
                            TextSpan(text: 'You have an active extended '),
                            TextSpan(
                              text: 'warranty',
                              style: AppTextStyles.small.copyWith(
                                color: theme.colorScheme.onSecondary,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ', so a change to this date is reviewed '
                                  'by our team before it takes effect.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 28.h),

              PrimaryButton(onTap: _saveChanges, title: 'Save changes'),
              SizedBox(height: 30.h),

              // Optimistic-save note
              Text(
                'Saved immediately in the app. If the server rejects it, '
                'we roll the change back and tell you why.',
                style: AppTextStyles.small.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
