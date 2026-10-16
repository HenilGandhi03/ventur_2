import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_component_theme.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),

    scaffoldBackgroundColor: AppColors.background,

    filledButtonTheme: AppComponentTheme.filledButton,

    inputDecorationTheme: AppComponentTheme.inputDecoration,

    cardTheme: AppComponentTheme.cardTheme,
    appBarTheme: AppComponentTheme.appBar,
  );
}
