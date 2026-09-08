import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class HouseholdSetupScreen extends StatefulWidget {
  const HouseholdSetupScreen({super.key});

  @override
  State<HouseholdSetupScreen> createState() => _HouseholdSetupScreenState();
}

class _HouseholdSetupScreenState extends State<HouseholdSetupScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  bool _wantsReminders = false;

  @override
  void initState() {
    super.initState();
    // Rebuild so the button enables/disables as the name is typed.
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _nameController.text.trim().isNotEmpty;

  void _createWallet() {
    debugPrint(
      'Name: ${_nameController.text.trim()}, '
      'City: ${_cityController.text.trim()}, '
      'reminders: $_wantsReminders',
    );
    Get.to(() => NavigatorScreen(), transition: Transition.rightToLeft);
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    final theme = Theme.of(context);
    return Container(
      height: 54.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(2.r),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: AppTextStyles.small.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles.small.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,

              // Kicker
              Text(
                'WELCOME',
                style: AppTextStyles.medium2.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),

              SizedBox(height: 12.h),

              // Screen title
              Text(
                "Let's set up your household",
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 25.sp,
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: 12.h),

              // Body
              Text(
                'Your number is verified. Two details and your wallet is ready.',
                style: AppTextStyles.semiBold.copyWith(
                  fontSize: 15.sp,
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: 30.h),

              // Full name
              Text(
                'FULL NAME',
                style: AppTextStyles.medium2.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 10.h),
              _inputField(controller: _nameController, hint: 'Your name'),

              SizedBox(height: 24.h),

              // City — optional
              RichText(
                text: TextSpan(
                  style: AppTextStyles.medium2.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'CITY'),
                    TextSpan(
                      text: ' — optional',
                      style: AppTextStyles.small.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              _inputField(
                controller: _cityController,
                hint: 'For service scheduling',
              ),

              SizedBox(height: 24.h),

              // Consent checkbox
              GestureDetector(
                onTap: () => setState(() => _wantsReminders = !_wantsReminders),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22.w,
                      height: 22.w,
                      margin: EdgeInsets.only(top: 2.h),
                      decoration: BoxDecoration(
                        color: _wantsReminders
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: _wantsReminders
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onPrimaryFixed,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(2.r), // never round
                      ),
                      child: _wantsReminders
                          ? Icon(
                              Icons.check,
                              size: 14.sp,
                              color: theme.colorScheme.onPrimary,
                            )
                          : null,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Send me service reminders and offers. You can '
                        'change this any time in your profile.',
                        style: AppTextStyles.small.copyWith(
                          fontSize: 14.sp,
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              Opacity(
                opacity: _canSubmit ? 1 : 0.45,
                child: PrimaryButton(
                  onTap: _canSubmit ? _createWallet : null,
                  title: 'Create my wallet',
                  // suffixIcon: Icon(
                  //   Icons.arrow_right_alt_sharp,
                  //   color: theme.colorScheme.onInverseSurface,
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
