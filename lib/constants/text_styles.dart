import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle get heading => GoogleFonts.manrope(
    fontSize: 42.sp,
    fontWeight: FontWeight.w900,
    height: 1.0,
  );
  static TextStyle get small =>
      GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600);
  static TextStyle get medium =>
      GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w600);
  static TextStyle get regular =>
      GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w600);
  static TextStyle get buttonLabel => GoogleFonts.manrope(
    fontSize: 17.sp,
    fontWeight: FontWeight.w800,
    height: 1.0,
  );
  static TextStyle get semiBold =>
      GoogleFonts.manrope(fontSize: 21.sp, fontWeight: FontWeight.w800);
  static TextStyle get medium1 => GoogleFonts.manrope(
    fontSize: 17.sp,
    fontWeight: FontWeight.w800,
    height: 1.0,
  );
  static TextStyle get medium2 =>
      GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w600);
  static TextStyle get body =>
      GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w900);

  static TextStyle get screenTitle =>
      GoogleFonts.manrope(fontSize: 22.sp, fontWeight: FontWeight.w900);

  static TextStyle get dialogTitle => GoogleFonts.sourceSerif4(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.20,
    letterSpacing: -0.15,
  );

  static TextStyle get displayFigure => GoogleFonts.sourceSerif4(
    fontSize: 26.sp,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  static TextStyle get priceLarge => GoogleFonts.sourceSerif4(
    fontSize: 33.sp, // 32–34 px
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  static TextStyle get emphasisBody => GoogleFonts.sourceSerif4(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    height: 1.35, // use 1.45 for RTL/Hebrew screens
  );

  static TextStyle get listItemTitle => GoogleFonts.sourceSerif4(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.30,
  );

  static TextStyle get fieldValue => GoogleFonts.sourceSerif4(
    fontSize: 17.sp, // 16–18 px
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0.6, // +0.04em, used on phone/OTP digits
  );

  static TextStyle get metaCaption => GoogleFonts.sourceSerif4(
    fontSize: 13.sp, // 12–14 px
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static TextStyle get kicker => GoogleFonts.sourceSerif4(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1.30,
    letterSpacing: 1.5, // +0.14em, uppercase — Latin only, drop for Hebrew
  );

  static TextStyle get chipLabel => GoogleFonts.sourceSerif4(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0.4, // +0.04em
  );

  static TextStyle get fieldLabel => GoogleFonts.sourceSerif4(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 1.2, // +0.10em, uppercase — Latin only, drop for Hebrew
  );

  static TextStyle get italicAside => GoogleFonts.sourceSerif4(
    fontSize: 15.5.sp, // 14–17 px
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.45,
  );
}
