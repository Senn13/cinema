import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme get _poppinsTextTheme => GoogleFonts.poppinsTextTheme();
  static TextStyle? get _whiteHeadlineSmall => _poppinsTextTheme.headlineSmall?.copyWith(
        fontSize: Sizes.dimen_20.sp.toDouble(),
        color: Colors.white,
      );
  static TextTheme getTextTheme() => TextTheme(
        headlineSmall: _whiteHeadlineSmall ?? TextStyle(
          fontSize: Sizes.dimen_20.sp.toDouble(),
          color: Colors.white,
      ),
  );
}
