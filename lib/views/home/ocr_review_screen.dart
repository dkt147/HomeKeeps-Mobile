import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/navigation_controller.dart';
import 'package:home_keeps/controller/ocr_controller.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/models/ocr_model.dart';

import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/views/home/camera_capture_screen.dart';
import 'package:home_keeps/widgets/app_dropdown.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class OcrReviewScreen extends StatefulWidget {
  final CaptureType captureType;
  final String imagePath;
  final OcrJobModel? job; // extracted data coming back from the status API
  final String? jobId;

  const OcrReviewScreen({
    super.key,
    required this.captureType,
    required this.imagePath,
    this.job,
    this.jobId,
  });

  @override
  State<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends State<OcrReviewScreen> {
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _purchaseOnController;
  late final TextEditingController _delievryOnController;
  late final TextEditingController _serialNumber;

  late final TextEditingController _priceController;
  late final TextEditingController _whereFromController;
  late final ProductController productController;
  late final OcrController ocrController;

  bool _isSaving = false;

  // MANUFACTURER dropdown state
  final Map<String, String> _manufacturerNameToId = {};
  String? _selectedManufacturerName;
  String? get _selectedManufacturerId =>
      _manufacturerNameToId[_selectedManufacturerName];

  // CATEGORY dropdown state
  final Map<String, String> _categoryNameToId = {};
  String? _selectedCategoryName;
  String? get _selectedCategoryId => _categoryNameToId[_selectedCategoryName];
  final Map<String, String> _storeNameToId = {};
  String? _selectedStoreName;

  String? get _selectedStoreId => _storeNameToId[_selectedStoreName];

  @override
  void initState() {
    super.initState();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());
    ocrController = Get.isRegistered<OcrController>()
        ? Get.find<OcrController>()
        : Get.put(OcrController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.getManufacturers();
      productController.getCategories();
      productController.getStores();
    });

    final extracted = widget.job?.extracted;

    _makeController = TextEditingController(
      text: extracted?.manufacturer ?? '',
    );
    _modelController = TextEditingController(text: extracted?.model ?? '');
    _purchaseOnController = TextEditingController(
      text: extracted?.purchaseDate ?? '',
    );
    _serialNumber = TextEditingController(text: extracted?.serialNumber ?? '');
    _delievryOnController = TextEditingController(
      text: extracted?.delievryDate ?? '',
    );
    _priceController = TextEditingController(
      text: extracted?.purchasePrice?.value != null
          ? '${extracted!.purchasePrice!.value} ${extracted.purchasePrice?.currency ?? ''}'
                .trim()
          : '',
    );
    _whereFromController = TextEditingController(
      text: extracted?.storeName ?? '',
    );
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _purchaseOnController.dispose();
    _priceController.dispose();
    _whereFromController.dispose();
    super.dispose();
  }

  void _retake() {
    Get.off(
      () => CameraCaptureScreen(captureType: widget.captureType),
      transition: Transition.rightToLeft,
    );
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text =
          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _confirmAndSave() async {
    if (widget.jobId == null) {
      Get.snackbar(
        'Missing data',
        "We couldn't find this scan. Please retake the photo.",
      );
      return;
    }

    if (_selectedCategoryId == null) {
      Get.snackbar(
        'Select a category',
        'Please choose a category before saving.',
      );
      return;
    }

    if (_selectedManufacturerId == null) {
      Get.snackbar(
        'Select a manufacturer',
        'Please choose a manufacturer before saving.',
      );
      return;
    }
    if (_selectedStoreId == null) {
      Get.snackbar('Select Store', 'Please choose a store before saving.');
      return;
    }

    setState(() => _isSaving = true);

    final success = await ocrController.confirmJob(
      categoryId: _selectedCategoryId!,
      manufacturerId: _selectedManufacturerId!,
      model: _modelController.text.trim(),
      purchasePrice: double.tryParse(
        _priceController.text.trim().split(' ').first,
      ),
      purchaseDate: _purchaseOnController.text.trim(),
      deliveryDate: _delievryOnController.text.trim(),
      storeId: _selectedStoreId!,
      serialNumber: _serialNumber.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      final navigationController = Get.find<NavigationController>();
      navigationController.selectIndex(0);
      Get.offAll(
        () => const NavigatorScreen(),
        transition: Transition.rightToLeft,
      );
    }
    // error/success snackbars are already handled inside OcrController
    // via handleError/handleSuccess - no need to duplicate here.
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    Widget? suffixIcon,
    VoidCallback? ontap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.small.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 52.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: TextField(
            controller: controller,
            onTap: ontap,
            keyboardType: keyboardType,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            style: AppTextStyles.small.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              isCollapsed: true,
              border: InputBorder.none,
              suffixIconConstraints: BoxConstraints(
                maxHeight: 22.h,
                maxWidth: 22.w,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return GetBuilder<ProductController>(
      builder: (controller) {
        if (controller.isCategoriesLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CATEGORY',
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              AppSkeleton(width: double.infinity, height: 52.h, radius: 8),
            ],
          );
        }

        if (controller.categoriesError) {
          return Row(
            children: [
              Expanded(
                child: Text(
                  "Couldn't load categories",
                  style: AppTextStyles.small.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => controller.getCategories(),
                child: const Text('Try again'),
              ),
            ],
          );
        }

        final categories = controller.categoriesModel?.data ?? [];
        _categoryNameToId
          ..clear()
          ..addEntries(
            categories
                .where((c) => c.id != null && c.name != null)
                .map((c) => MapEntry(c.name!, c.id!)),
          );

        return AppDropdownField(
          label: 'CATEGORY',
          hint: 'Select category',
          value: _selectedCategoryName,
          items: _categoryNameToId.keys.toList(),
          onChanged: (value) {
            setState(() => _selectedCategoryName = value);
          },
        );
      },
    );
  }

  Widget _buildManufacturerField() {
    return GetBuilder<ProductController>(
      builder: (controller) {
        if (controller.isManufacturersLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MANUFACTURER',
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              AppSkeleton(width: double.infinity, height: 52.h, radius: 8),
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
                    color: Theme.of(context).colorScheme.onSecondary,
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

        final manufacturers = controller.manufacturersModel?.data ?? [];
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 100.w,
        leading: GestureDetector(
          onTap: _retake,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Retake',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 15.sp,
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm the details',
                style: AppTextStyles.semiBold.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 20.h),
              _buildCategoryField(),
              SizedBox(height: 14.h),
              _buildManufacturerField(),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'Model',
                      controller: _modelController,
                    ),
                  ),
                  // Expanded(
                  //   child: _buildInputField(
                  //     label: 'Make',
                  //     controller: _makeController,
                  //   ),
                  // ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildInputField(
                      label: 'Price',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'Purchase Date',
                      controller: _purchaseOnController,
                      ontap: () => _pickDate(_purchaseOnController),
                      suffixIcon: Icon(
                        Icons.calendar_today_outlined,
                        size: 18.sp,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildInputField(
                      label: 'Delievry Date',
                      controller: _delievryOnController,
                      ontap: () => _pickDate(_delievryOnController),
                      suffixIcon: Icon(
                        Icons.calendar_today_outlined,
                        size: 18.sp,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              _buildInputField(
                label: 'Serial Number',
                controller: _serialNumber,
              ),
              SizedBox(height: 14.h),
              GetBuilder<ProductController>(
                builder: (controller) {
                  if (controller.isStoresLoading) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Where from',
                          style: AppTextStyles.small.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
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

                  if (controller.storesError) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Couldn't load stores",
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => controller.getStores(),
                          child: const Text('Try again'),
                        ),
                      ],
                    );
                  }

                  final stores = controller.storesModel?.data ?? [];

                  _storeNameToId
                    ..clear()
                    ..addEntries(
                      stores
                          .where(
                            (store) => store.id != null && store.name != null,
                          )
                          .map((store) => MapEntry(store.name!, store.id!)),
                    );

                  return AppDropdownField(
                    label: 'STORE',
                    hint: 'Where you bought it',
                    value: _selectedStoreName,
                    items: _storeNameToId.keys.toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStoreName = value;
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 30.h),
              PrimaryButton(
                onTap: _isSaving ? null : _confirmAndSave,
                title: _isSaving ? 'Saving…' : 'Confirm',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
