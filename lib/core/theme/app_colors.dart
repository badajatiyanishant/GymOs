import 'package:flutter/material.dart';

/// GymPro brand palette. A premium, energetic scheme: deep indigo/violet with
/// an electric lime accent — reads as "fitness + tech", differentiates from the
/// generic blue SaaS look while staying professional.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6C4DFF); // Electric violet
  static const Color primaryDark = Color(0xFF4B32C3);
  static const Color secondary = Color(0xFF00E5A0); // Neon mint
  static const Color accent = Color(0xFFCCFF00); // Lime energy

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutrals — light
  static const Color lightBg = Color(0xFFF6F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Neutrals — dark
  static const Color darkBg = Color(0xFF0B0B12);
  static const Color darkSurface = Color(0xFF14141F);
  static const Color darkCard = Color(0xFF1B1B29);
  static const Color darkBorder = Color(0xFF2A2A3C);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C4DFF), Color(0xFF9A6BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00E5A0), Color(0xFFCCFF00)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Chart palette (used by fl_chart across reports).
  static const List<Color> chartPalette = [
    Color(0xFF6C4DFF),
    Color(0xFF00E5A0),
    Color(0xFFF59E0B),
    Color(0xFF3B82F6),
    Color(0xFFEF4444),
    Color(0xFFCCFF00),
  ];
}
