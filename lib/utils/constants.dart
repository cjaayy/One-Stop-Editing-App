import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBlue = Color(0xFF1A1A2E);
  static const Color darkRed = Color(0xFF3D0814);
  static const Color darkPurple = Color(0xFF2D0A1C);
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
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.darkBlue,
      AppColors.darkRed,
      AppColors.darkPurple,
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
