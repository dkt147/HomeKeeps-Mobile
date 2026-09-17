import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/auth_controller.dart';
import 'package:home_keeps/views/auth/login_screen.dart';
import 'package:home_keeps/views/profile/deletion_account_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _remindersEnabled = true;
  late final AuthController controller;

  @override
  void initState() {
    super.initState();
    try {
      controller = Get.find<AuthController>();
    } catch (e) {
      controller = Get.put(AuthController());
    }

    _remindersEnabled = controller.getCachedMarketingConsent(fallback: true);

    controller.fetchProfile().then((_) {
      if (!mounted) return;
      final consent = controller.profile?.customer?.consentMarketing;
      if (consent != null) {
        setState(() => _remindersEnabled = consent);
      }
    });
  }

  Widget _sectionKicker(String label) {
    return Text(
      label,
      style: AppTextStyles.medium2.copyWith(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  Widget _linkRow({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            const Spacer(),
            Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right,
              size: 18.sp,
              color: theme.colorScheme.onPrimaryFixed,
            ),
          ],
        ),
      ),
    );
  }

  String _formatAddress(String? addressLine, String? city) {
    final line = (addressLine ?? '').trim();
    final cityName = (city ?? '').trim();
    if (line.isEmpty && cityName.isEmpty) return '—';
    if (line.isEmpty) return cityName;
    if (cityName.isEmpty) return line;
    return '$line, $cityName';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: GetBuilder<AuthController>(
            builder: (controller) {
              final customer = controller.profile?.customer;
              final household = controller.profile?.household;
              final isLoading =
                  controller.isLoadingProfile && controller.profile == null;

              final name = customer?.fullName?.trim();
              final displayName = (name == null || name.isEmpty)
                  ? (isLoading ? 'Loading…' : '—')
                  : name;

              final phone = customer?.phone ?? (isLoading ? '' : '—');
              final email = customer?.email ?? (isLoading ? '' : '—');
              final address = _formatAddress(
                household?.addressLine,
                household?.city,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.verticalSpace,
                  // Name + phone
                  Text(
                    displayName,
                    style: AppTextStyles.semiBold.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    phone,
                    style: AppTextStyles.small.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),

                  SizedBox(height: 30.h),
                  _sectionKicker('details'.tr),
                  SizedBox(height: 6.h),

                  _linkRow(label: 'email'.tr, value: email, onTap: () {}),
                  _linkRow(
                    label: 'address'.tr,
                    value: address,
                    onTap: () {
                      // TODO: edit address
                    },
                  ),

                  SizedBox(height: 24.h),
                  _sectionKicker('PREFERENCES'),
                  SizedBox(height: 10.h),

                  // Service reminders toggle
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service reminders and offers',
                              style: AppTextStyles.semiBold.copyWith(
                                fontSize: 18.sp,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Change this whenever you like',
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 46.w,
                        height: 27.h,
                        child: Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: _remindersEnabled,
                            onChanged: (v) async {
                              // Optimistic UI update — flips immediately.
                              setState(() => _remindersEnabled = v);

                              final success = await controller
                                  .updateMarketingConsent(v);

                              // Revert if the API call failed (error
                              // snackbar already shown via handleError()).
                              if (!success && mounted) {
                                setState(() => _remindersEnabled = !v);
                              }
                            },
                            activeThumbColor: Colors.white,
                            activeTrackColor: theme.colorScheme.primary,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor:
                                theme.colorScheme.onPrimaryFixed,
                            trackOutlineColor: const WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // SizedBox(height: 10.h),

                  // _linkRow(
                  //   label: 'Language',
                  //   value: "English",
                  //   onTap: () {
                  //     Get.to(
                  //       () => LanguageScreen(),
                  //       transition: Transition.rightToLeft,
                  //     );
                  //   },
                  // ),
                  SizedBox(height: 24.h),
                  _sectionKicker('ACCOUNT'),
                  SizedBox(height: 10.h),

                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog(
                        context: context,
                        title: "Logout",
                        message: "Are you sure you want to logout?",
                        confirmText: "Yes",

                        onConfirm: () async {
                          final success = await controller.logout();
                          if (!success) {
                            throw Exception('Logout failed');
                          }
                        },
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            size: 20.sp,
                            color: theme.colorScheme.onPrimaryFixed,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Sign out',
                            style: AppTextStyles.semiBold.copyWith(
                              fontSize: 16.sp,

                              color: theme.colorScheme.onPrimaryFixed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => DeletionAccountScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20.sp,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Request account deletion',
                            style: AppTextStyles.buttonLabel.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog({
    required String title,
    required String message,
    required String confirmText,
    required Future<void> Function() onConfirm,
    required BuildContext context,
  }) {
    bool isLoading = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              title: Text(
                title,
                style: AppTextStyles.dialogTitle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              content: Text(
                message,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          // Navigator.of(context).pop();
                        },
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.body.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await onConfirm();

                            if (Get.isDialogOpen ?? false) {
                              Get.offAll(
                                () => LoginScreen(),
                                transition: Transition.rightToLeft,
                              );
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          confirmText,
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onInverseSurface,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }
}
