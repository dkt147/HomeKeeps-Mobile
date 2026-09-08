import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/auth/login_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class DeletionAccountScreen extends StatefulWidget {
  const DeletionAccountScreen({super.key});

  @override
  State<DeletionAccountScreen> createState() => _DeletionAccountScreenState();
}

class _DeletionAccountScreenState extends State<DeletionAccountScreen> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leadingWidth: 120.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 16.sp,
                  color: theme.colorScheme.onPrimaryFixed,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Profile',
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 30.verticalSpace,
              // Name + phone
              Text(
                'Requesting deletion of your account',
                style: AppTextStyles.semiBold.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "We handle the request within 30 days. Here is exactly what happens.",
                style: AppTextStyles.semiBold.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: 30.h),
              _buildRecordsRow(
                icon: Icons.close_sharp,
                iconColor: theme.colorScheme.error,
                title:
                    "Your appliances, documents and service history are erased.",
              ),
              _buildRecordsRow(
                icon: Icons.receipt,
                iconColor: theme.colorScheme.outline,
                title:
                    "Records we are legally required to keep — invoices, warranty contracts — are separated and stripped of anything identifying you.",
              ),
              _buildRecordsRow(
                icon: Icons.info_outlined,
                iconColor: theme.colorScheme.outline,
                title: "Any active extended warranty ends and is not refunded.",
              ),

              // Service reminders toggle
              SizedBox(height: 20.h),
              Text(
                "WHY ARE YOU LEAVING? — optional",
                style: AppTextStyles.medium2.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              10.verticalSpace,
              TextField(
                controller: searchController,
                style: AppTextStyles.small.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                maxLines: 6,

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 8.h,
                  ),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'It helps us improve',
                  hintStyle: AppTextStyles.small.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              20.verticalSpace,

              PrimaryButton(
                onTap: () {
                  _showConfirmDialog(
                    context: context,
                    title: "Send the deletion request?",
                    message:
                        "You can cancel it by contacting us at any point in the next 30 days. After that it cannot be undone.?",
                    confirmText: "Yes,send it",

                    onConfirm: () async {},
                  );
                },
                title: "Send the request",
                bg: theme.colorScheme.error,
              ),
              20.verticalSpace,
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Text(
                    "Keep account",
                    style: AppTextStyles.semiBold.copyWith(
                      color: theme.colorScheme.onPrimaryFixed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordsRow({
    required String title,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor),
        10.w.horizontalSpace,
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.small.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }

  void _showConfirmDialog({
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
                          Navigator.of(context).pop();
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
