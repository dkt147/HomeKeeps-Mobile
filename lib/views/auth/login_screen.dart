import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/views/auth/otp_verification_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  Country _selectedCountry = Country(
    phoneCode: '972',
    countryCode: 'IL',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Israel',
    example: '50-000-0000',
    displayName: 'Israel',
    displayNameNoCountryCode: 'Israel',
    e164Key: '',
  );

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      showSearch: true,
      favorite: const ['IL', 'PK', 'US', 'GB'],

      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _phoneController.clear(); // old digits no longer make sense
        });
      },
    );
  }

  String get _digitsOnly => _phoneController.text.replaceAll(RegExp(r'\D'), '');

  int get _expectedDigits =>
      _selectedCountry.example.replaceAll(RegExp(r'\D'), '').length;

  String? get _phoneError {
    if (_digitsOnly.isEmpty) return null; // don't error before typing
    if (_expectedDigits > 0 && _digitsOnly.length != _expectedDigits) {
      return 'That is not a complete ${_selectedCountry.name} mobile '
          'number. $_expectedDigits digits after the country code.';
    }
    return null;
  }

  bool get _hasError => _phoneError != null;

  bool get _canSubmit => _digitsOnly.isNotEmpty && !_hasError;

  String get _fullPhoneNumber => '+${_selectedCountry.phoneCode}$_digitsOnly';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error; // --color-accent-2
    final errorFill = theme.colorScheme.onError; // --color-accent-2-100
    final errorTextColor = theme.colorScheme.error; // --color-accent-2-700

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,

              Text(
                'SIGN IN',
                style: AppTextStyles.medium2.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                'What is your\nphone number?',
                style: AppTextStyles.semiBold.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: 16.h),

              // Text(
              //   'We send a one-time code. No password to remember.',
              //   style: AppTextStyles.semiBold.copyWith(
              //     color: theme.colorScheme.primary,
              //   ),
              // ),

              // SizedBox(height: 30.h),

              // Field label — switches to the error color when invalid
              Text(
                'MOBILE NUMBER',
                style: AppTextStyles.medium2.copyWith(
                  color: _hasError
                      ? errorTextColor
                      : theme.colorScheme.onSecondary,
                ),
              ),

              SizedBox(height: 12.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // COUNTRY CODE
                  GestureDetector(
                    onTap: _selectCountry,
                    child: Container(
                      height: 54.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCountry.countryCode,
                            style: AppTextStyles.small.copyWith(
                              color: theme.colorScheme.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(width: 7.w),

                          Text(
                            '+${_selectedCountry.phoneCode}',
                            style: AppTextStyles.small.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // PHONE NUMBER
                  Expanded(
                    child: Container(
                      height: 54.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: _hasError
                            ? errorFill
                            : theme.colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(2.r),
                        border: _hasError
                            ? Border.all(color: errorColor, width: 1.5)
                            : null,
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],

                        style: AppTextStyles.small.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),

                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '50-000-0000',

                          hintStyle: AppTextStyles.small.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Inline validation message
              if (_hasError) ...[
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 17.sp,
                      color: errorTextColor,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        _phoneError!,
                        style: AppTextStyles.small.copyWith(
                          color: errorTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 40.h),

              Opacity(
                opacity: _canSubmit ? 1 : 0.45,
                child: PrimaryButton(
                  onTap: () {
                    Get.offAll(
                      () => NavigatorScreen(
                        // phoneNumber: '+972 50-712-4488',
                      ),
                      transition: Transition.rightToLeft,
                    );
                  },
                  // suffixIcon: Icon(
                  //   Icons.arrow_right_alt_sharp,
                  //   color: theme.colorScheme.onInverseSurface,
                  // ),
                  title: 'Login',
                ),
              ),

              SizedBox(height: 30.h),

              // RichText(
              //   text: TextSpan(
              //     style: AppTextStyles.small.copyWith(
              //       color: theme.colorScheme.onSecondary,
              //     ),
              //     children: [
              //       const TextSpan(text: 'By continuing you agree to the '),

              //       TextSpan(
              //         text: 'terms of use',
              //         style: AppTextStyles.small.copyWith(
              //           fontSize: 14.sp,
              //           color: theme.colorScheme.onPrimaryFixed,
              //         ),
              //         recognizer: TapGestureRecognizer()
              //           ..onTap = () {
              //             // TODO
              //           },
              //       ),

              //       const TextSpan(text: ' and the '),

              //       TextSpan(
              //         text: 'privacy policy',
              //         style: AppTextStyles.semiBold.copyWith(
              //           fontSize: 14.sp,
              //           color: theme.colorScheme.onPrimaryFixed,
              //         ),
              //         recognizer: TapGestureRecognizer()
              //           ..onTap = () {
              //             // TODO
              //           },
              //       ),

              //       const TextSpan(text: '.'),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
