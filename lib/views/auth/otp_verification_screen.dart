import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/controller/auth_controller.dart';

import 'package:pinput/pinput.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber; // e.g. '+972501234567' (with country code)

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  final AuthController controller = Get.find<AuthController>();

  static const _resendSeconds = 47;
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  bool _isError = false;
  int _attemptsLeft = 2;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = _resendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _timerLabel {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _numberWord(int n) {
    const words = ['Zero', 'One', 'Two', 'Three', 'Four', 'Five'];
    return n >= 0 && n < words.length ? words[n] : '$n';
  }

  Future<void> _resendCode() async {
    setState(() {
      _isError = false;
      _attemptsLeft = 2;
    });
    _pinController.clear();

    await controller.login(phone: widget.phoneNumber, navigateOnSuccess: false);
    _startTimer();
  }

  void _showWrongCodeError() {
    setState(() {
      _isError = true;
      if (_attemptsLeft > 0) _attemptsLeft--;
    });
    _pinController.clear();
    _focusNode.requestFocus();
  }

  Future<void> _verify(String code) async {
    if (code.length < 6 || controller.isVerifyingOtp) return;

    final success = await controller.verifyOtp(
      phone: widget.phoneNumber,
      code: code,
    );

    if (!success) {
      _showWrongCodeError();
      return;
    }

    setState(() => _isError = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 44.w,
      height: 62.h,
      textStyle: TextStyle(
        fontFamily: AppTextStyles.semiBold.fontFamily,

        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: theme.colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(2.r),
      border: Border.all(color: theme.colorScheme.onPrimaryFixed, width: 1.5),
    );

    final submittedPinTheme = defaultPinTheme;

    // All six boxes flip to this when the code comes back wrong.
    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      color: theme.colorScheme.onError, // --color-accent-2-100
      borderRadius: BorderRadius.circular(2.r),
      border: Border.all(
        color: theme.colorScheme.error,
        width: 1.5,
      ), // --color-accent-2
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 18.sp,
                        color: theme
                            .colorScheme
                            .onPrimaryFixed, // --color-accent700
                      ),
                      SizedBox(width: 6.w),
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

              SizedBox(height: 10.h),

              // Kicker
              Text(
                'VERIFICATION',
                style: AppTextStyles.medium2.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),

              SizedBox(height: 16.h),

              // Screen title
              Text(
                'Enter the six-digit code',
                style: AppTextStyles.semiBold.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: 10.h),

              // Sent to <number>
              RichText(
                text: TextSpan(
                  style: AppTextStyles.small.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  children: [
                    const TextSpan(text: 'Sent to '),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 15.sp,
                        color: theme.colorScheme.onPrimaryFixed,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // OTP boxes — forced LTR container even in RTL screens
              Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  controller: _pinController,
                  focusNode: _focusNode,
                  autofocus: true,
                  defaultPinTheme: _isError ? errorPinTheme : defaultPinTheme,
                  focusedPinTheme: _isError ? errorPinTheme : focusedPinTheme,
                  submittedPinTheme: _isError
                      ? errorPinTheme
                      : submittedPinTheme,
                  separatorBuilder: (index) => SizedBox(width: 9.w),
                  showCursor: true,
                  cursor: Container(
                    width: 2,
                    height: 26.h,
                    // change this to whatever color you want the cursor to be
                    color: theme.colorScheme.primary, // --color-accent
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) {
                    if (_isError) setState(() => _isError = false);
                  },

                  // Reads the SMS autofill hint the OS provides
                  onCompleted: _verify,
                ),
              ),

              // Inline wrong-code message
              if (_isError) ...[
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 17.sp,
                      color: theme.colorScheme.error,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'That code is not correct. ${_numberWord(_attemptsLeft)} '
                        'attempts left before the number is locked for 30 minutes.',
                        style: AppTextStyles.small.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 30.h),

              GetBuilder<AuthController>(
                builder: (controller) {
                  return PrimaryButton(
                    onTap: () => _verify(_pinController.text),
                    title: controller.isVerifyingOtp
                        ? 'Please wait...'
                        : 'Verify',
                  );
                },
              ),

              SizedBox(height: 20.h),

              if (_isError)
                GestureDetector(
                  onTap: _resendCode,
                  child: Text(
                    'Send a new code',
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 15.sp,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16.sp,
                      color: theme.colorScheme.onPrimaryFixed,
                    ),
                    SizedBox(width: 6.w),
                    if (_secondsLeft > 0)
                      Text(
                        'Resend available in  $_timerLabel',
                        style: AppTextStyles.small.copyWith(
                          color: theme.colorScheme.onPrimaryFixed,
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _resendCode,
                        child: Text(
                          'Resend code',
                          style: AppTextStyles.small.copyWith(
                            color: theme.colorScheme.onPrimaryFixed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

              // Italic aside — hidden once the wrong-code error is showing
              if (!_isError)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Text(
                    'The code fills in automatically when the SMS arrives.',
                    style: AppTextStyles.small.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
