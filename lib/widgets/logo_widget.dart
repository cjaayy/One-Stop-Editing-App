import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LogoWidget extends StatelessWidget {
  final double fontSize;
  final double iconSize;

  const LogoWidget({
    super.key,
    this.fontSize = 20,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'One',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
            Text(
              'Stop',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
            Text(
              'Editor',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
            Text(
              AppStrings.tagline,
              style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize * 0.45,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        SizedBox(width: iconSize * 0.24),
        Icon(
          Icons.camera_alt,
          size: iconSize,
          color: Colors.white,
        ),
      ],
    );
  }
}
