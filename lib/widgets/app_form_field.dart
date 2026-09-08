import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';

class AppFormField extends StatelessWidget {
  final String label;
  final String? labelSuffix;
  final String hint;
  final TextEditingController? controller;
  final String? displayValue;

  final String? prefixText;
  final Widget? prefixIcon; // NEW

  final Widget? trailing;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? helperText;
  final bool filled;

  const AppFormField({
    super.key,
    required this.label,
    this.labelSuffix,
    required this.hint,
    this.controller,
    this.displayValue,
    this.prefixText,
    this.prefixIcon, // NEW
    this.trailing,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.maxLength,
    this.helperText,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final valueColor = theme.colorScheme.primary;
    final hintColor = theme.colorScheme.onSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.medium2.copyWith(color: hintColor),
            children: [
              TextSpan(text: label),
              if (labelSuffix != null) TextSpan(text: ' $labelSuffix'),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(2.r),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                // PREFIX ICON
                if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 8.w)],

                // PREFIX TEXT
                if (prefixText != null) ...[
                  Text(
                    prefixText!,
                    style: AppTextStyles.small.copyWith(
                      color: valueColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 4.w),
                ],

                Expanded(
                  child: displayValue != null || readOnly
                      ? Text(
                          displayValue ?? hint,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.small.copyWith(
                            color: (displayValue != null && filled)
                                ? valueColor
                                : hintColor,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : TextField(
                          controller: controller,
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          keyboardType: keyboardType,
                          maxLength: maxLength,
                          style: AppTextStyles.small.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            counterText: '',
                            hintText: hint,
                            hintStyle: AppTextStyles.small.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                ),

                // TRAILING
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),

        if (helperText != null) ...[
          SizedBox(height: 6.h),
          Text(
            helperText!,
            style: AppTextStyles.small.copyWith(color: hintColor),
          ),
        ],
      ],
    );
  }
}
