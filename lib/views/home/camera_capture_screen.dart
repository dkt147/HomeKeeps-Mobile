import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/home/manual_entry_screen.dart';
import 'package:home_keeps/views/home/ocr_review_screen.dart';
import 'package:permission_handler/permission_handler.dart';

enum CaptureType { invoice, label }

class CameraCaptureScreen extends StatefulWidget {
  final CaptureType captureType;
  final String categoryName;

  const CameraCaptureScreen({
    super.key,
    required this.captureType,
    this.categoryName = 'DISHWASHER',
  });

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initFuture;
  String? _cameraError;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() {
        _cameraError = status.isPermanentlyDenied
            ? 'Camera permission is off. Enable it in phone settings.'
            : 'Camera permission was not granted.';
      });
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraError = 'No camera available on this device.');
        return;
      }
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      _initFuture = _controller!.initialize();
      await _initFuture;
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera init failed: $e');
      setState(() => _cameraError = "Couldn't open the camera.");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }
    setState(() => _isCapturing = true);
    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      Get.off(
        () => OcrReviewScreen(
          captureType: widget.captureType,
          imagePath: file.path,
        ),
        transition: Transition.rightToLeft,
      );
    } catch (e) {
      setState(() => _cameraError = "Couldn't take the photo. Try again.");
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _skipToStockImage() {
    Get.off(() => ManualEntryScreen(), transition: Transition.rightToLeft);
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step kicker header
              Text(
                'STEP 2 OF 3 · ${widget.categoryName.toUpperCase()}',
                style: AppTextStyles.medium2.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 6.h),

              // Title
              Text(
                'Take a picture of it',
                style: AppTextStyles.semiBold.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 6.h),

              // Subtitle
              Text(
                'So you recognise it instantly in your wallet. One tap, and you never think about it again.',
                style: AppTextStyles.small.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 20.h),

              // Camera Frame Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _cameraError != null
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.w),
                              child: Text(
                                _cameraError!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          )
                        : (_controller != null && _initFuture != null)
                        ? FutureBuilder<void>(
                            future: _initFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  _controller!.value.isInitialized) {
                                return CameraPreview(_controller!);
                              }
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      size: 36.sp,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Camera preview',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 36.sp,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Camera preview',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Floating Circular Shutter Button
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _cameraError == null ? _capture : null,
                      child: Container(
                        width: 68.w,
                        height: 68.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: .2),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: _isCapturing
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: _skipToStockImage,
                      child: Text(
                        'Skip — use the stock image',
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
