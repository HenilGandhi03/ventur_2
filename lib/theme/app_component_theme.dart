import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppComponentTheme {
  static final filledButton = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.white, // Use the primary color from AppColors
      foregroundColor: const Color(0xFF12345B),
      minimumSize: const Size.fromHeight(48),
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final inputDecoration = InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  static final cardTheme = CardThemeData(
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static final appBar = AppBarTheme(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.textPrimary,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
  );
}
