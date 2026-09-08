import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';

import 'package:home_keeps/views/home/repair_covered_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';
import 'package:image_picker/image_picker.dart';

class FaultOptionsScreen extends StatefulWidget {
  final String applianceName;

  const FaultOptionsScreen({
    super.key,
    this.applianceName = 'BOSCH DISHWASHER',
  });

  @override
  State<FaultOptionsScreen> createState() => _FaultOptionsScreenState();
}

class _FaultOptionsScreenState extends State<FaultOptionsScreen> {
  static const _options = [
    "It won't turn on",
    "The water won't drain",
    "It's leaking",
    'Dishes come out dirty',
    "It's making a loud noise",
    'Something else',
  ];

  String? _selected = "The water won't drain";
  final _notesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _attachedImagePath;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _canContinue => _selected != null;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _attachedImagePath = image.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _continue() {
    debugPrint(
      'Fault: $_selected, notes: ${_notesController.text}, image: $_attachedImagePath',
    );
    Get.to(
      () => RepairCoveredScreen(
        manufacturer: 'Bosch',
        providerName: 'BSH Service Israel',
        providerPhoneDisplay: '*6110',
        providerHours: 'Sun–Thu 08:00–17:00',
        model: 'SMV4HVX00E',
        serial: 'FD9902 004417',
        caseReference: '#4471',
      ),
      transition: Transition.rightToLeft,
    );
    // Get.to(() => CheckingCoverageScreen(), transition: Transition.rightToLeft);
  }

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
                option,
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

              // Options List
              for (final option in _options) _radioRow(option),

              SizedBox(height: 10.h),

              // Text Notes Container
              Container(
                height: 110.h,
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextField(
                  controller: _notesController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: AppTextStyles.small.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText:
                        'Anything else worth telling the technician? Optional.',
                    hintStyle: AppTextStyles.small.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              // Image Attachment Action Row
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 18.sp,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Add a photo',
                            style: AppTextStyles.semiBold.copyWith(
                              fontSize: 14.sp,

                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryFixed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  if (_attachedImagePath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        File(_attachedImagePath!),
                        width: 48.w,
                        height: 48.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),

              SizedBox(height: 36.h),

              // Bottom Primary Action Button
              PrimaryButton(
                onTap: _canContinue ? _continue : null,
                title: 'Check my cover',
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
