import 'package:flutter/material.dart';
import 'package:games/core/utils/typography.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: CustomColors.primary,
      secondary: CustomColors.primary,
    ),
    splashColor: CustomColors.primary,
    textTheme: AppTypography.lightTheme,
    cardTheme: CardTheme(
      surfaceTintColor: CustomColors.lightPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),

      ),
    ),
  );
}
