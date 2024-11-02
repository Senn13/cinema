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

  static TextStyle? get whiteSubtitle1 => _poppinsTextTheme.titleMedium?.copyWith(
    fontSize: Sizes.dimen_16.sp.toDouble(),
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
        titleMedium: whiteSubtitle1,
        bodyMedium: whiteBodyText2,
  );
}

extension ThemeTextExtension on TextTheme {
  TextStyle? get royalBlueSubtitle1 => titleMedium?.copyWith(
    color: AppColor.royalBlue,
    fontWeight: FontWeight.w600,
  );
}

