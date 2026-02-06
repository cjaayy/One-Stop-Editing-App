import 'package:flutter/material.dart';

/// A reusable social sign-in/sign-up button widget
class SocialButton extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color? iconColor;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;

  const SocialButton({
    super.key,
    this.icon,
    this.iconWidget,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.iconColor,
    required this.onPressed,
    this.height = 54,
    this.borderRadius = 14,
  }) : assert(icon != null || iconWidget != null,
            'Either icon or iconWidget must be provided');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null)
              iconWidget!
            else if (icon != null)
              Icon(icon, color: iconColor ?? textColor, size: 26),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A social button with an outline style
class SocialButtonOutlined extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final Color borderColor;
  final Color textColor;
  final Color? iconColor;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;

  const SocialButtonOutlined({
    super.key,
    this.icon,
    this.iconWidget,
    required this.label,
    this.borderColor = Colors.white30,
    this.textColor = Colors.white,
    this.iconColor,
    required this.onPressed,
    this.height = 54,
    this.borderRadius = 14,
  }) : assert(icon != null || iconWidget != null,
            'Either icon or iconWidget must be provided');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.05),
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null)
              iconWidget!
            else if (icon != null)
              Icon(icon, color: iconColor ?? textColor, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
