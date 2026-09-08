import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/app_assets.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/navigation_controller.dart';
import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/views/home/camera_capture_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class OcrReviewScreen extends StatefulWidget {
  final CaptureType captureType;
  final String imagePath;

  const OcrReviewScreen({
    super.key,
    required this.captureType,
    required this.imagePath,
  });

  @override
  State<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends State<OcrReviewScreen> {
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _boughtOnController;
  late final TextEditingController _priceController;
  late final TextEditingController _whereFromController;
  late final TextEditingController _serialController;

  bool _isLoadingOcr = true;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController();
    _modelController = TextEditingController();
    _boughtOnController = TextEditingController();
    _priceController = TextEditingController();
    _whereFromController = TextEditingController();
    _serialController = TextEditingController();
    _runOcr();
  }

  Future<void> _runOcr() async {
    await Future.delayed(const Duration(milliseconds: 600));
    _makeController.text = 'Bosch';
    _modelController.text = 'SMV4HVX00E';
    _boughtOnController.text = '12 Oct 2024';
    _priceController.text = 'ILS 2,790';
    _whereFromController.text = 'Electra Home, Rishon LeZion';
    if (mounted) setState(() => _isLoadingOcr = false);
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _boughtOnController.dispose();
    _priceController.dispose();
    _whereFromController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  void _retake() {
    Get.off(
      () => CameraCaptureScreen(captureType: widget.captureType),
      transition: Transition.rightToLeft,
    );
  }

  void _confirmAndSave() {
    final navigationController = Get.find<NavigationController>();
    navigationController.selectIndex(0);
    Get.offAll(
      () => const NavigatorScreen(),
      transition: Transition.rightToLeft,
    );
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _boughtOnController.text =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    Widget? suffixIcon,
    VoidCallback? ontap,
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
        child: _isLoadingOcr
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Reading the photo…',
                      style: AppTextStyles.medium2.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Appliance Thumbnail + Step Header
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
                                'STEP 3 OF 3',
                                style: AppTextStyles.medium2.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Anything you know',
                                style: AppTextStyles.semiBold.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "All of it optional. Add it later if you'd rather.",
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
                    SizedBox(height: 20.h),

                    // Two Column Row: Make & Model
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'Make',
                            controller: _makeController,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildInputField(
                            label: 'Model',
                            controller: _modelController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // Two Column Row: Bought on & Price
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'Bought on',
                            controller: _boughtOnController,
                            ontap: _pickDate,
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
                            label: 'Price',
                            controller: _priceController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // Where from Field
                    _buildInputField(
                      label: 'Where from',
                      controller: _whereFromController,
                    ),
                    SizedBox(height: 14.h),

                    // Serial Number Field
                    _buildInputField(
                      label: 'Serial number',
                      controller: _serialController,
                      hintText: 'Usually on a sticker at the back',
                      suffixIcon: Icon(
                        Icons.qr_code_scanner,
                        size: 18.sp,
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Hint caption below serial number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 15.sp,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            "Worth adding when you get a chance — it's the first thing a maker asks for.",
                            style: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 28.h),

                    // Warranty Informational Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 22.sp,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'From the purchase date we work out your warranty automatically, and start watching the clock.',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // Bottom Primary Action Button
                    PrimaryButton(
                      onTap: _confirmAndSave,
                      title: 'Put it in my wallet',
                    ),
                    // SizedBox(height: 16.h),
                  ],
                ),
              ),
      ),
    );
  }
}
