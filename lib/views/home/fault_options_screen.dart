// import 'dart:io'; // photo feature filhal band
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';

import 'package:home_keeps/views/home/repair_covered_screen.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';
// import 'package:image_picker/image_picker.dart'; // photo feature filhal band

class FaultOptionsScreen extends StatefulWidget {
  final String productId;
  final String applianceName;
  final String categoryId;

  const FaultOptionsScreen({
    super.key,
    required this.productId,
    required this.applianceName,
    required this.categoryId,
  });

  @override
  State<FaultOptionsScreen> createState() => _FaultOptionsScreenState();
}

class _FaultOptionsScreenState extends State<FaultOptionsScreen> {
  late final ProductController productController;

  // API wali asal value (jaise not_starting, other)
  String? _selected;
  final _notesController = TextEditingController();

  // Preferred slot (optional)
  DateTime? _slotDate;
  TimeOfDay? _slotTime;

  // Photo filhal band
  // final ImagePicker _picker = ImagePicker();
  // String? _attachedImagePath;

  @override
  void initState() {
    super.initState();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFaultTypes());
  }

  void _loadFaultTypes() {
    productController.getFaultTypes(categoryId: widget.categoryId);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _isOther => _selected == 'other';

  bool get _canContinue =>
      _selected != null &&
      (!_isOther || _notesController.text.trim().isNotEmpty);

  List<String> _buildOptions(List<String> apiTypes) {
    final list = apiTypes.where((e) => e != 'other').toList();
    list.add('other');
    return list;
  }

  String _label(String value) {
    if (value.isEmpty) return value;
    final s = value.replaceAll('_', ' ');
    return s[0].toUpperCase() + s.substring(1);
  }

  // ---------------- Photo (filhal band) ----------------
  // Future<void> _pickImage() async {
  //   try {
  //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       setState(() {
  //         _attachedImagePath = image.path;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('Error picking image: $e');
  //   }
  // }

  // ---------------- Date / Time ----------------
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _slotDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _slotDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _slotTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _slotTime = picked);
  }

  List<dynamic>? _buildPreferredSlots() {
    if (_slotDate == null && _slotTime == null) return [];

    if (_slotDate == null || _slotTime == null) {
      Get.snackbar(
        'Pick date and time',
        'Please choose both a date and a time, or clear them.',
      );
      return null;
    }

    final slot = DateTime(
      _slotDate!.year,
      _slotDate!.month,
      _slotDate!.day,
      _slotTime!.hour,
      _slotTime!.minute,
    );

    if (slot.isBefore(DateTime.now())) {
      Get.snackbar('Time has passed', 'Please pick a time in the future.');
      return null;
    }

    return [slot.toUtc().toIso8601String()];
  }

  // ---------------- Check my cover ----------------
  Future<void> _continue() async {
    if (_selected == null) return;

    final slots = _buildPreferredSlots();
    if (slots == null) return;

    final description = _isOther
        ? _notesController.text.trim()
        : _label(_selected!);

    final caseId = await productController.createServiceCase(
      productId: widget.productId,
      faultType: _selected!,
      description: description,
      preferredSlots: slots,
    );

    if (caseId == null || !mounted) return;

    Get.to(
      () => RepairCoveredScreen(caseId: caseId),
      transition: Transition.rightToLeft,
    );
  }

  // ---------------- UI pieces ----------------
  Widget _radioRow(String option) {
    final isSelected = _selected == option;
    return GestureDetector(
      onTap: () => setState(() => _selected = option),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                _label(option),
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 15.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    return GetBuilder<ProductController>(
      builder: (controller) {
        if (controller.isFaultTypesLoading) {
          return Column(
            children: List.generate(
              6,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: AppSkeleton(
                  width: double.infinity,
                  height: 56.h,
                  radius: 20,
                ),
              ),
            ),
          );
        }

        if (controller.faultTypesError) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Couldn't load the options",
                    style: AppTextStyles.small.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: _loadFaultTypes,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        final options = _buildOptions(controller.faultTypes);
        return Column(
          children: [for (final option in options) _radioRow(option)],
        );
      },
    );
  }

  Widget _buildNotesField() {
    return Container(
      height: 110.h,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: TextField(
        controller: _notesController,
        onChanged: (_) => setState(() {}), // button enable/disable ke liye
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: AppTextStyles.small.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: "Tell us what's going wrong",
          hintStyle: AppTextStyles.small.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotPicker() {
    final loc = MaterialLocalizations.of(context);
    final hasAny = _slotDate != null || _slotTime != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'PREFERRED VISIT TIME · OPTIONAL',
            style: AppTextStyles.medium2.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _pickerTile(
                icon: Icons.calendar_today_outlined,
                text: _slotDate == null
                    ? 'Pick a date'
                    : loc.formatMediumDate(_slotDate!),
                onTap: _pickDate,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _pickerTile(
                icon: Icons.access_time,
                text: _slotTime == null
                    ? 'Pick a time'
                    : _slotTime!.format(context),
                onTap: _pickTime,
              ),
            ),
          ],
        ),
        if (hasAny)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() {
                _slotDate = null;
                _slotTime = null;
              }),
              child: Text(
                'Clear',
                style: AppTextStyles.small.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
      ],
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
        leadingWidth: 90.w,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
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
                  'Back',
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
              // Header Row: Appliance Image + Category Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/q-washer.png", scale: 3.0),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.applianceName.toUpperCase(),
                          style: AppTextStyles.medium2.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "What's it doing?",
                          style: AppTextStyles.semiBold.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Options List (API se)
              _buildOptionsList(),

              // Description: sirf jab "Other" select ho
              if (_isOther) ...[SizedBox(height: 10.h), _buildNotesField()],

              SizedBox(height: 20.h),

              // Preferred slot: date + time
              _buildSlotPicker(),

              // ---------- Photo row (filhal band) ----------
              // SizedBox(height: 14.h),
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: _pickImage,
              //       child: Container(
              //         height: 48.h,
              //         padding: EdgeInsets.symmetric(horizontal: 18.w),
              //         decoration: BoxDecoration(
              //           color: Theme.of(context).colorScheme.onPrimary,
              //           borderRadius: BorderRadius.circular(24.r),
              //         ),
              //         child: Row(
              //           children: [
              //             Icon(
              //               Icons.camera_alt_outlined,
              //               size: 18.sp,
              //               color: Theme.of(context).colorScheme.onPrimaryFixed,
              //             ),
              //             SizedBox(width: 8.w),
              //             Text(
              //               'Add a photo',
              //               style: AppTextStyles.semiBold.copyWith(
              //                 fontSize: 14.sp,
              //                 color: Theme.of(context).colorScheme.onPrimaryFixed,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 12.w),
              //     if (_attachedImagePath != null)
              //       ClipRRect(
              //         borderRadius: BorderRadius.circular(12.r),
              //         child: Image.file(
              //           File(_attachedImagePath!),
              //           width: 48.w,
              //           height: 48.h,
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //   ],
              // ),
              SizedBox(height: 36.h),

              // Bottom Primary Action Button
              GetBuilder<ProductController>(
                builder: (controller) {
                  final busy = controller.isCaseCreating;
                  return PrimaryButton(
                    onTap: (_canContinue && !busy) ? _continue : null,
                    title: busy ? 'Checking…' : 'Check my cover',
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
