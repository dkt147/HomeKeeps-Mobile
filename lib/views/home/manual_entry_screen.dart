import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/app_dropdown.dart';
import 'package:home_keeps/widgets/app_form_field.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _manufacturerController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _storeController = TextEditingController();
  final _serialController = TextEditingController();

  DateTime? _purchaseDate;
  String? selectedAppliance;

  @override
  void initState() {
    super.initState();

    // _modelController.text = 'HBG5585';
    // _priceController.text = '3,150';
    // _purchaseDate = DateTime(2026, 3, 4);
  }

  @override
  void dispose() {
    _manufacturerController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _storeController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  String get _formattedDate {
    final d = _purchaseDate;
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  void _addToWallet() {
    debugPrint(
      'Model: ${_modelController.text}, Purchase date: $_formattedDate, '
      'Price: ${_priceController.text}, Store: ${_storeController.text}, '
      'Serial: ${_serialController.text}',
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSecondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 120.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 16.sp,
                  color: theme.colorScheme.onPrimaryFixed,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Back',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryFixed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              SizedBox(height: 16.h),

              Text(
                'Tell us about the appliance',
                style: AppTextStyles.semiBold.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 25.h),

              AppDropdownField(
                label: 'CATEGORY-REQUIRED',
                hint: 'Select appliance',
                value: selectedAppliance,
                items: const [
                  'Refrigerator',
                  'Washing Machine',
                  'Air Conditioner',
                  'Microwave',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedAppliance = value;
                  });
                },
              ),
              10.verticalSpace,
              Text(
                'Chosen from a fixed list so coverage rules can be applied.',
                style: AppTextStyles.small.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),

              SizedBox(height: 24.h),
              Text(
                'HELPFUL, NOT REQUIRED',
                style: AppTextStyles.medium2.copyWith(color: hintColor),
              ),
              SizedBox(height: 20.h),

              // MANUFACTURER / MODEL
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppFormField(
                      label: 'MANUFACTURER',
                      hint: 'e.g. Bosch',
                      controller: _manufacturerController,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppFormField(
                      label: 'MODEL',
                      hint: 'Model number',
                      controller: _modelController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // PURCHASE DATE / PRICE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppFormField(
                      label: 'PURCHASE DATE',
                      hint: 'DD.MM.YYYY',
                      displayValue: _formattedDate.isEmpty
                          ? null
                          : _formattedDate,
                      onTap: _pickDate,
                      trailing: Icon(
                        Icons.calendar_today_outlined,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppFormField(
                      label: 'PRICE',
                      hint: '0',
                      controller: _priceController,
                      prefixText: '₪',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // STORE
              AppFormField(
                label: 'STORE',
                hint: 'Where you bought it',
                controller: _storeController,
              ),
              SizedBox(height: 15.h),

              // SERIAL NUMBER
              AppFormField(
                label: 'SERIAL NUMBER',
                hint: 'Up to 64 characters',
                controller: _serialController,
                maxLength: 64,
                helperText:
                    'Worth adding — it is what a manufacturer '
                    'asks for first when you report a fault.',
              ),
              SizedBox(height: 28.h),

              PrimaryButton(onTap: _addToWallet, title: 'Add to my wallet'),
            ],
          ),
        ),
      ),
    );
  }
}
