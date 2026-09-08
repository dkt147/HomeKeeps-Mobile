import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';

enum WalletChipStatus {
  covered,
  technicianScheduled,
  checkCoverage,
  noCoverage,
  awaitingConfirmation,
  resolved,
}

class WalletChipData {
  final String label;
  final Color fill;
  final Color textColor;
  const WalletChipData(this.label, this.fill, this.textColor);
}

WalletChipData chipDataFor(WalletChipStatus status) {
  switch (status) {
    case WalletChipStatus.covered:
      return const WalletChipData(
        'Covered',
        Color(0xFFcbeeff),
        Color(0xFF004961),
      );
    case WalletChipStatus.technicianScheduled:
      return const WalletChipData(
        'Technician scheduled',
        Color(0xFFCBEEFF),
        Color(0xFF004961),
      );
    case WalletChipStatus.checkCoverage:
      return const WalletChipData(
        'Check coverage',
        Color(0xFFffdee6),
        Color(0xffaa0b56),
      );
    case WalletChipStatus.noCoverage:
      return const WalletChipData(
        'No coverage',
        Color(0xFFeae7e7),
        Color(0xFF444141),
      );
    case WalletChipStatus.awaitingConfirmation:
      return const WalletChipData(
        'Awaiting confirmation',
        Color(0xFFEAE7E7),
        Color(0xFF444141),
      );
    case WalletChipStatus.resolved:
      return const WalletChipData(
        'Resolved',
        Color(0xFFEAE7E7),
        Color(0xFF444141),
      );
  }
}

/// Small pill chip — ≈22px tall, 2px radius, 11px label.
class StatusChip extends StatelessWidget {
  final WalletChipStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final data = chipDataFor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: data.fill,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Text(
        data.label,
        style: AppTextStyles.chipLabel.copyWith(color: data.textColor),
      ),
    );
  }
}

/// A row inside "Your wallet": leading icon, title, model, chip + date, caret.
/// If [chipStatus] is null, [statusText] is shown as plain text instead
/// (matches the "No coverage" row, which has no pill in the design).
class WalletRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String model;
  final WalletChipStatus? chipStatus;
  final String? statusText;
  final String? dateText;
  final VoidCallback? onTap;

  const WalletRow({
    super.key,
    required this.icon,
    required this.title,
    required this.model,
    this.chipStatus,
    this.statusText,
    this.dateText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(2.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 27.sp, color: theme.colorScheme.primary),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.listItemTitle.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Model $model',
                    style: AppTextStyles.metaCaption.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      if (chipStatus != null)
                        StatusChip(status: chipStatus!)
                      else if (statusText != null)
                        Text(
                          statusText!,
                          style: AppTextStyles.chipLabel.copyWith(
                            color: theme.colorScheme.onPrimaryFixed,
                          ),
                        ),
                      if (dateText != null) ...[
                        SizedBox(width: 8.w),
                        Text(
                          dateText!,
                          style: AppTextStyles.metaCaption.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: theme.colorScheme.onPrimaryFixed,
            ),
          ],
        ),
      ),
    );
  }
}

/// One of the three "add a first appliance" paths on the empty wallet screen.
class AddPathRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const AddPathRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(2.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30.sp, color: theme.colorScheme.primary),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.listItemTitle.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.metaCaption.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
