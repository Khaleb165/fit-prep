import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary colors
  static const Color deepBlue = Color(0xFF1E6FD9);
  static const Color brightBlue = Color(0xFF2FA4FF);
  static const Color tealBlue = Color(0xFF2FB7A8);

  // Secondary colors
  static const Color vibrantGreen = Color(0xFF34C759);
  static const Color lightGreen = Color(0xFF7DFF8A);
  static const Color darkGreen = Color(0xFF1FAF5A);

  // Neutral UI colors
  static const Color backgroundLightGrey = Color(0xFFF4F6F8);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderDivider = Color(0xFFE5E7EB);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [deepBlue, tealBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ctaButtonGradient = LinearGradient(
    colors: [vibrantGreen, darkGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
