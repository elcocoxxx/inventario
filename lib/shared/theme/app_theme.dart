import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Tema global. Al aplicarse en MaterialApp, TODAS las pantallas
/// (diálogos, inputs, botones, snackbars, appbar...) heredan el mismo estilo
/// sin tener que repetir colores en cada página.
class AppTheme {
  AppTheme._();

  static const double radius = 14;

  static OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: color, width: width),
      );

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    const scheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      surface: AppColors.card,
      onSurface: AppColors.textPrimary,
      error: AppColors.danger,
      outline: AppColors.border,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.card,
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),

      // ---------- AppBar ----------
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),

      // ---------- Drawer ----------
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
      ),

      // ---------- Inputs ----------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        contentPadding: AppSpacing.inputPadding,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary, 1.6),
        errorBorder: _border(AppColors.danger),
        focusedErrorBorder: _border(AppColors.danger, 1.6),
      ),

      // ---------- Botones ----------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(0, 48),
          elevation: 0,
          shape: shape,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: AppColors.border),
          shape: shape,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: shape,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ---------- Listas / chips / feedback ----------
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.field,
        side: const BorderSide(color: AppColors.border),
        labelStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.field,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: shape,
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primary),
    );
  }
}
