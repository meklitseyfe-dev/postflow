import 'package:flutter/material.dart';

/// PostFlow brand and neutral palette.
abstract final class AppColors {
  // Brand
  static const Color brand = Color(0xFF5B4BF5);
  static const Color brandDeep = Color(0xFF3A2BD8);
  static const Color brandLight = Color(0xFF8B7EFF);
  static const Color accent = Color(0xFF14B8A6);

  // Light neutrals
  static const Color ink = Color(0xFF0F172A);
  static const Color inkMuted = Color(0xFF64748B);
  static const Color canvas = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E7EE);

  // Dark neutrals
  static const Color inkDark = Color(0xFFE8EAF2);
  static const Color inkMutedDark = Color(0xFF98A2B8);
  static const Color canvasDark = Color(0xFF0B0F1A);
  static const Color surfaceDark = Color(0xFF141927);
  static const Color borderDark = Color(0xFF242B3D);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);

  /// Signature gradient for the logo mark and hero surfaces.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandDeep, brand, Color(0xFF8B5CF6)],
  );
}
