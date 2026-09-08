import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/auth/login_screen.dart';
import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/views/auth/sign_in_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class OpenWalletScreen extends StatelessWidget {
  const OpenWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Wallet Icon Tile with Soft Shadow
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .3),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
              ),
              SizedBox(height: 36.h),

              // Title Header
              Text(
                "Let's open\nyour wallet",
                textAlign: TextAlign.center,
                style: AppTextStyles.heading.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16.h),

              // Subtitle
              Text(
                'Just verify your phone number. No\npassword, no sign-up form.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 36.h),

              // Primary CTA Button
              PrimaryButton(
                onTap: () {
                  Get.to(
                    () => SignInPhoneScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
                title: 'Open my wallet',
              ),
              SizedBox(height: 12.h),

              // Secondary Button
              PrimaryButton(
                bg: Theme.of(context).colorScheme.onPrimary,
                textcolor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  Get.offAll(
                    () => LoginScreen(),
                    transition: Transition.rightToLeft,
                  );
                  // Get.offAll(
                  //   () => NavigatorScreen(),
                  //   transition: Transition.rightToLeft,
                  // );
                },
                title: 'I already have one — sign in',
              ),
              SizedBox(height: 24.h),

              // Terms & Privacy Notice
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.small.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 11.sp,
                  ),
                  children: [
                    const TextSpan(text: 'Continuing means you accept the '),
                    TextSpan(
                      text: 'Terms of Use',
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' and\n'),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
