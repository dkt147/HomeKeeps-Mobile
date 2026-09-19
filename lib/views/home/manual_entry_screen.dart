import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/widgets/app_dropdown.dart';
import 'package:home_keeps/widgets/app_form_field.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class ManualEntryScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const ManualEntryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  late final ProductController productController;

  final _manufacturerController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _storeController = TextEditingController();
  final _serialController = TextEditingController();

  DateTime? _purchaseDate;

  // manufacturer name -> id, dropdown text-based hai is liye lookup rakha hai
  final Map<String, String> _manufacturerNameToId = {};
  String? _selectedManufacturerName;
  String? get _selectedManufacturerId =>
      _manufacturerNameToId[_selectedManufacturerName];

  PlatformFile? _pickedPhoto;

  @override
  void initState() {
    super.initState();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => productController.getManufacturers(),
    );
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

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'heic'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pickedPhoto = result.files.first);
    }
  }

  Future<void> _addToWallet() async {
    if (_selectedManufacturerId == null) {
      Get.snackbar('Missing info', 'Manufacturer select karein');
      return;
    }
    if (_purchaseDate == null) {
      Get.snackbar('Missing info', 'Purchase date select karein');
      return;
    }

    final ok = await productController.createProduct(
      categoryId: widget.categoryId,
      manufacturerId: _selectedManufacturerId!,
      model: _modelController.text.trim(),
      purchasePrice: _priceController.text.trim(),
      deliveryDate:
          "${_purchaseDate!.year.toString().padLeft(4, '0')}-"
          "${_purchaseDate!.month.toString().padLeft(2, '0')}-"
          "${_purchaseDate!.day.toString().padLeft(2, '0')}",
      serialNumber: _serialController.text.trim(),
      photo: _pickedPhoto?.path != null ? File(_pickedPhoto!.path!) : null,
    );

    if (ok) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
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
              SizedBox(height: 16.h),

              Text(
                'Tell us about the appliance',
                style: AppTextStyles.semiBold.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 25.h),

              // Category — pichli screen se aa chuki hai, read-only dikha rahe hain
              AppDropdownField(
                label: 'CATEGORY',
                hint: 'Select appliance',
                value: widget.categoryName,
                items: [widget.categoryName],
                onChanged: null, // disabled — already chosen
              ),
              10.verticalSpace,
              Text(
                'Chosen from a fixed list so coverage rules can be applied.',
                style: AppTextStyles.small.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),

              SizedBox(height: 24.h),

              // MANUFACTURER — API se
              GetBuilder<ProductController>(
                builder: (controller) {
                  if (controller.isManufacturersLoading) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MANUFACTURER',
                          style: AppTextStyles.medium2.copyWith(
                            color: hintColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppSkeleton(
                          width: double.infinity,
                          height: 52.h,
                          radius: 8,
                        ),
                      ],
                    );
                  }

                  if (controller.manufacturersError) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Couldn't load manufacturers",
                            style: AppTextStyles.small.copyWith(
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => controller.getManufacturers(),
                          child: const Text('Try again'),
                        ),
                      ],
                    );
                  }

                  final manufacturers =
                      controller.manufacturersModel?.data ?? [];
                  _manufacturerNameToId
                    ..clear()
                    ..addEntries(
                      manufacturers
                          .where((m) => m.id != null && m.name != null)
                          .map((m) => MapEntry(m.name!, m.id!)),
                    );

                  return AppDropdownField(
                    label: 'MANUFACTURER',
                    hint: 'Select manufacturer',
                    value: _selectedManufacturerName,
                    items: _manufacturerNameToId.keys.toList(),
                    onChanged: (value) {
                      setState(() => _selectedManufacturerName = value);
                    },
                  );
                },
              ),

              SizedBox(height: 24.h),
              Text(
                'HELPFUL, NOT REQUIRED',
                style: AppTextStyles.medium2.copyWith(color: hintColor),
              ),
              SizedBox(height: 20.h),

              // MANUFACTURER (free text) / MODEL
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
              SizedBox(height: 15.h),

              // PHOTO (optional)
              OutlinedButton.icon(
                onPressed: _pickPhoto,
                icon: Icon(Icons.add_a_photo_outlined, size: 18.sp),
                label: Text(
                  _pickedPhoto?.name ?? 'Add a photo (optional)',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(height: 28.h),

              GetBuilder<ProductController>(
                builder: (controller) => PrimaryButton(
                  onTap: controller.isCreatingProduct ? () {} : _addToWallet,
                  title: controller.isCreatingProduct
                      ? 'Adding...'
                      : 'Add to my wallet',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
