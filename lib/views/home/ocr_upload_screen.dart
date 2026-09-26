import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/ocr_controller.dart';
import 'package:home_keeps/views/home/camera_capture_screen.dart';
import 'package:home_keeps/views/home/ocr_review_screen.dart';
import 'package:home_keeps/widgets/app_dropdown.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class OcrUploadScreen extends StatefulWidget {
  final CaptureType captureType;
  final String imagePath;

  const OcrUploadScreen({
    super.key,
    required this.captureType,
    required this.imagePath,
  });

  @override
  State<OcrUploadScreen> createState() => _OcrUploadScreenState();
}

class _OcrUploadScreenState extends State<OcrUploadScreen> {
  final OcrController ocrController = Get.put(OcrController());

  // label -> value map, same pattern as the Category/Manufacturer dropdowns
  final Map<String, String> _typeLabelToValue = const {
    'Invoice': 'invoice',
    'Label': 'label',
    'Warranty certificate': 'warranty_certificate',
    'Other': 'other',
  };
  String? _selectedTypeLabel = 'Invoice';
  String get _selectedType =>
      _typeLabelToValue[_selectedTypeLabel] ?? 'invoice';

  @override
  void dispose() {
    Get.delete<OcrController>();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await ocrController.submitForOcr(
      imageFile: File(widget.imagePath),
      documentType: _selectedType,
    );

    if (!mounted) return;

    if (success) {
      Get.off(
        () => OcrReviewScreen(
          captureType: widget.captureType,
          imagePath: widget.imagePath,
          job: ocrController.job,
          jobId: ocrController.jobId,
        ),
        transition: Transition.rightToLeft,
      );
    }
    // error/success snackbars are already handled inside OcrController
    // via handleError/handleSuccess - no need to duplicate here.
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OcrController>(
      builder: (controller) {
        final isBusy = controller.isUploading || controller.isPolling;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm document type',
                    style: AppTextStyles.semiBold.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.file(
                      File(widget.imagePath),
                      height: 260.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  AppDropdownField(
                    label: 'Document type',
                    hint: 'Select document type',
                    value: _selectedTypeLabel,
                    items: _typeLabelToValue.keys.toList(),
                    onChanged: isBusy
                        ? null
                        : (v) => setState(() => _selectedTypeLabel = v),
                  ),
                  const Spacer(),
                  if (isBusy)
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(height: 10.h),
                            Text(
                              controller.isUploading
                                  ? 'Uploading photo…'
                                  : 'Reading the photo…',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  PrimaryButton(
                    onTap: isBusy ? null : _submit,
                    title: isBusy ? 'Please wait…' : 'Continue',
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
