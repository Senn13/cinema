import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme get _poppinsTextTheme => GoogleFonts.poppinsTextTheme();

  static TextStyle? get _whiteHeadlineSmall => _poppinsTextTheme.headlineSmall?.copyWith(
        fontSize: Sizes.dimen_20.sp.toDouble(),
        color: Colors.white,
      );
  static TextStyle? get _whiteHeadlineMedium => _poppinsTextTheme.headlineMedium?.copyWith(
        fontSize: Sizes.dimen_24.sp.toDouble(),
        color: Colors.white,
      );

  static TextStyle? get _whiteHeadlineLarge => _poppinsTextTheme.headlineLarge?.copyWith(
        fontSize: Sizes.dimen_32.sp.toDouble(),
        color: Colors.white,
      );

  static TextStyle? get _whiteSubtitle2 => _poppinsTextTheme.titleSmall?.copyWith(
        fontSize: Sizes.dimen_16.sp.toDouble(),
        color: Colors.white,
      );

  static TextStyle? get whiteSubtitle1 => _poppinsTextTheme.titleMedium?.copyWith(
    fontSize: Sizes.dimen_20.sp.toDouble(),
    color: Colors.white,
  );

  static TextStyle? get _whiteButton => _poppinsTextTheme.labelLarge?.copyWith(
    fontSize: Sizes.dimen_14.sp.toDouble(),
    color: Colors.white,
  );

  static TextStyle? get whiteBodyText3 => _poppinsTextTheme.bodyLarge?.copyWith(
    fontSize: Sizes.dimen_14.sp.toDouble(),
    color: Colors.white,
  );

  static TextStyle? get whiteBodyText2 => _poppinsTextTheme.bodyMedium?.copyWith(
    color: Colors.white,
    fontSize: Sizes.dimen_14.sp.toDouble(),
    wordSpacing: 0.25,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static getTextTheme() => TextTheme(
        headlineSmall: _whiteHeadlineSmall,
        headlineMedium: _whiteHeadlineMedium,
        headlineLarge: _whiteHeadlineLarge,
        titleMedium: whiteSubtitle1,
        bodyMedium: whiteBodyText2,
        labelLarge: _whiteButton,
        titleSmall: _whiteSubtitle2,
        bodyLarge: whiteBodyText3,
  );
}

extension ThemeTextExtension on TextTheme {
  TextStyle? get royalBlueSubtitle1 => titleMedium?.copyWith(
    color: AppColor.royalBlue,
    fontWeight: FontWeight.w600,
  );

  TextStyle? get greySubtitle1 => bodyLarge?.copyWith(
    color: Colors.grey,
  );

  TextStyle? get violetHeadline6 => headlineMedium?.copyWith(
    color: AppColor.violet,
  );

  TextStyle? get vulcanBodyText2 => bodyMedium?.copyWith(
    color: AppColor.vulcan,
    fontWeight: FontWeight.w600,
  );

  TextStyle? get vulcanBodyText3 => bodySmall?.copyWith(
    fontSize: Sizes.dimen_18.sp.toDouble(),
    color: AppColor.vulcan,
    fontWeight: FontWeight.w600,
  );

  TextStyle? get caption => bodySmall?.copyWith(
    color: Colors.grey,
    fontWeight: FontWeight.w600,
  );

  TextStyle? get orangeSubtitle1 => titleSmall?.copyWith(
        color: Colors.orangeAccent,
      );

}

