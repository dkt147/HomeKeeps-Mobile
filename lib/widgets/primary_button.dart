import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';

// Assuming you have a standard text style file, if not, I've defined it below.
// import 'package:home_keeps/constants/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final double? height, width;
  final String? fontfamily;
  final double? size;
  final Alignment? align;
  final Color? textcolor;
  final Color? borderColor;
  final Color? bg;
  final double? borderWidth;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const PrimaryButton({
    super.key,
    required this.onTap,
    required this.title,
    this.height,
    this.width,
    this.fontfamily,
    this.size,
    this.align,
    this.textcolor,
    this.bg,
    this.borderWidth,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),

        width: width ?? double.infinity,
        height: height ?? 54.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),

          color: bg ?? Theme.of(context).colorScheme.primary,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth ?? 1.0)
              : null,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 8.w)],

              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.buttonLabel.copyWith(
                    color: textcolor ?? Colors.white,
                    fontSize: size ?? 15.sp,
                  ),
                ),
              ),

              if (suffixIcon != null) ...[SizedBox(width: 8.w), suffixIcon!],
            ],
          ),
        ),
      ),
    );
  }
}
