import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

/// Call this to show the sheet. Resolves to:
/// - true  -> user tapped "Yes, that's mine"
/// - false -> user tapped "No, not mine"
/// - null  -> dismissed without choosing
Future<bool?> showDuplicateMatchSheet(
  BuildContext context, {
  required String applianceName, // "Samsung refrigerator"
  required String purchaseDate, // "12.04.2026"
  required String model,
  required String store,
  IconData icon = Icons.device_thermostat_outlined,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DuplicateMatchSheet(
      applianceName: applianceName,
      purchaseDate: purchaseDate,
      model: model,
      store: store,
      icon: icon,
    ),
  );
}

class DuplicateMatchSheet extends StatelessWidget {
  final String applianceName;
  final String purchaseDate;
  final String model;
  final String store;
  final IconData icon;

  const DuplicateMatchSheet({
    super.key,
    required this.applianceName,
    required this.purchaseDate,
    required this.model,
    required this.store,
    this.icon = Icons.device_thermostat_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onPrimaryFixed;

    return Container(
      padding: EdgeInsets.fromLTRB(26.w, 26.h, 26.w, 34.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary == const Color(0xFFF8F4F4)
            ? const Color(0xFFF8F4F4) // --color-neutral100
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(2.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ONE QUICK CHECK',
              style: AppTextStyles.kicker.copyWith(color: hintColor),
            ),
            SizedBox(height: 12.h),

            Text(
              'Did you buy a $applianceName on $purchaseDate?',
              style: AppTextStyles.screenTitle.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 20.h),

            // Matched item card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(icon, size: 27.sp, color: theme.colorScheme.primary),
                      Positioned(
                        top: -2,
                        right: -6,
                        child: Icon(
                          Icons.auto_awesome,
                          size: 12.sp,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 13.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applianceName,
                          style: AppTextStyles.listItemTitle.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Model $model',
                          style: AppTextStyles.body.copyWith(color: hintColor),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Purchased at $store · $purchaseDate',
                          style: AppTextStyles.body.copyWith(color: hintColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            Text(
              'Confirming adds it to your wallet with its warranty dates '
              'already filled in.',
              style: AppTextStyles.body.copyWith(color: hintColor),
            ),
            SizedBox(height: 24.h),

            PrimaryButton(
              onTap: () => Navigator.of(context).pop(true),
              title: "Yes, that's mine",
              prefixIcon: Icon(
                Icons.check,
                size: 18.sp,
                color: theme.colorScheme.onInverseSurface,
              ),
            ),
            SizedBox(height: 14.h),

            Center(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(
                  'No, not mine',
                  style: AppTextStyles.body.copyWith(color: hintColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
