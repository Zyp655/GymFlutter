import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static ThemeData get darkTheme {
    const primary = AppColors.gold;
    const background = AppColors.navyDark;
    const surface = AppColors.navyMedium;
    const surfaceContainer = AppColors.navyCard;
    const onSurface = AppColors.textWhite;
    const onSurfaceVariant = AppColors.textMuted;

    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: AppColors.navyDark,
      primaryContainer: primary.withValues(alpha: 0.2),
      onPrimaryContainer: primary,
      secondary: AppColors.goldLight,
      onSecondary: AppColors.navyDark,
      secondaryContainer: AppColors.goldDim.withValues(alpha: 0.2),
      onSecondaryContainer: AppColors.goldLight,
      surface: background,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.error.withValues(alpha: 0.2),
      onErrorContainer: AppColors.error,
      outline: AppColors.textSubtle,
      outlineVariant: AppColors.textSubtle.withValues(alpha: 0.3),
      shadow: Colors.black,
      surfaceContainerHighest: surfaceContainer,
      inverseSurface: onSurface,
      onInverseSurface: background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        foregroundColor: onSurface,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceContainer,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.textWhite.withValues(alpha: 0.06)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: primary,
        foregroundColor: AppColors.navyDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer.withValues(alpha: 0.8),
        hintStyle: const TextStyle(color: onSurfaceVariant),
        labelStyle: const TextStyle(color: onSurfaceVariant),
        prefixIconColor: primary,
        suffixIconColor: onSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.textWhite.withValues(alpha: 0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primary.withValues(alpha: 0.6),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.navyDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary,
          foregroundColor: AppColors.navyDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainer,
        selectedColor: primary.withValues(alpha: 0.2),
        labelStyle: const TextStyle(color: onSurface),
        secondaryLabelStyle: const TextStyle(color: primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.textWhite.withValues(alpha: 0.06)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary);
          }
          return const IconThemeData(color: onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(color: onSurfaceVariant, fontSize: 12);
        }),
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceContainer,
        contentTextStyle: const TextStyle(color: onSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(color: onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.textWhite.withValues(alpha: 0.06),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: onSurface,
        iconColor: primary,
      ),
    );
  }
}
