import 'package:flutter/material.dart';

/// Color palette for FitLife fitness app
class AppColors {
  // Primary Colors
  static const Color primaryGreen = Color(0xFFA8FF35);
  static const Color primaryGreenDark = Color(0xFF8FDB2D);

  // Background Colors
  static const Color darkBackground = Color(0xFF0D1612);
  static const Color darkGreenBackground = Color(0xFF1A2E26);
  static const Color coralBackground = Color(0xFFE89B8A);

  // Accent Colors
  static const Color tealAccent = Color(0xFF2D9B9B);
  static const Color runnerGreen = Color(0xFF5CA37D);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textDark = Color(0xFF1F2937);

  // Icon Colors
  static const Color iconLight = Color(0xFFFFFFFF);
  static const Color iconDark = Color(0xFF374151);

  // Input Field Colors
  static const Color inputBackground = Color(0xFF243832);
  static const Color inputBorder = Color(0xFF374151);

  // Gradient Colors
  static LinearGradient get welcomeGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE89B8A),
          Color(0xFF1A2520),
          Color(0xFF0A1410),
        ],
        stops: [0.0, 0.5, 1.0],
      );

  static LinearGradient get darkGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1A2E26),
          Color(0xFF0D1612),
        ],
      );
}