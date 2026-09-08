import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';

class AppDropdownField extends StatelessWidget {
  final String label;
  final String? labelSuffix;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? helperText;
  final bool enabled;

  const AppDropdownField({
    super.key,
    required this.label,
    this.labelSuffix,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.helperText,
    this.enabled = true,
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

        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 20.sp, color: hintColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.onPrimary,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 15.h,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.r),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.r),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.r),
              borderSide: BorderSide.none,
            ),
          ),

          hint: Text(
            hint,
            style: AppTextStyles.small.copyWith(
              color: hintColor,
              fontWeight: FontWeight.w400,
            ),
          ),

          style: AppTextStyles.small.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),

          dropdownColor: theme.colorScheme.surface,

          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.small.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),

          onChanged: enabled ? onChanged : null,
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
