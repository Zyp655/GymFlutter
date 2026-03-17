import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color navyDark = Color(0xFF0A1628);
  static const Color navyMedium = Color(0xFF0F2038);
  static const Color navyLight = Color(0xFF162A4A);
  static const Color navyCard = Color(0xFF132237);

  static const Color gold = Color(0xFFF4C025);
  static const Color goldLight = Color(0xFFFFD700);
  static const Color goldDim = Color(0xFFB8941C);

  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8E99A9);
  static const Color textSubtle = Color(0xFF5A6577);

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, goldLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient navyGradient = LinearGradient(
    colors: [navyDark, Color(0xFF1A1040)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration glassmorphismDecoration({
    double borderRadius = 16,
    bool withGoldBorder = false,
    double opacity = 0.15,
  }) {
    return BoxDecoration(
      color: navyLight.withValues(alpha: opacity + 0.3),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: withGoldBorder
            ? gold.withValues(alpha: 0.4)
            : textWhite.withValues(alpha: 0.08),
        width: withGoldBorder ? 1.5 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration goldGlowDecoration({double borderRadius = 16}) {
    return BoxDecoration(
      gradient: goldGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: gold.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
