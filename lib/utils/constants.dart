import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette: Purple, Pink, Green blend
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color secondaryPink = Color(0xFFEC4899);
  static const Color accentGreen = Color(0xFF10B981);

  // Surfaces & Backgrounds (No glows, clean dark slate)
  static const Color backgroundDark = Color(0xFF0D0B14);
  static const Color surfaceDark = Color(0xFF161324);
  static const Color surfaceCard = Color(0xFF1E1A30);
  static const Color surfaceBorder = Color(0xFF2D2545);

  // Typography
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  // Status & Feedback
  static const Color errorRed = Color(0xFFEF4444);

  // Legacy mappings for backward compatibility
  static const Color darkBlue = Color(0xFF0D0B14);
  static const Color darkRed = Color(0xFF161324);
  static const Color darkPurple = Color(0xFF1E1A30);
}

class AppStrings {
  static const String appName = 'One Stop Editor';
  static const String tagline = 'Edit. Create.';

  // Error messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String genericError = 'Something went wrong. Please try again.';

  // Success messages
  static const String verificationEmailSent =
      'Verification email sent! Please check your inbox.';
  static const String signupSuccess = 'Account created successfully!';
}

class AppGradient {
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D0B14),
      Color(0xFF151024),
      Color(0xFF0D0B14),
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
