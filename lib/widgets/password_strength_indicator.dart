import 'package:flutter/material.dart';

enum PasswordStrength { weak, fair, good, strong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length checks
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character type checks
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score <= 5) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  Color _getColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red.shade400;
      case PasswordStrength.fair:
        return Colors.orange.shade400;
      case PasswordStrength.good:
        return Colors.lightGreen.shade400;
      case PasswordStrength.strong:
        return Colors.green.shade400;
    }
  }

  String _getLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  int _getFilledBars(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.fair:
        return 2;
      case PasswordStrength.good:
        return 3;
      case PasswordStrength.strong:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _calculateStrength(password);
    final color = _getColor(strength);
    final label = _getLabel(strength);
    final filledBars = _getFilledBars(strength);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Strength bars
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index < filledBars
                        ? color
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // Strength label
          Row(
            children: [
              Icon(
                strength == PasswordStrength.strong
                    ? Icons.check_circle
                    : Icons.info_outline,
                color: color,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                'Password strength: $label',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Password requirement checklist
class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password must have:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            _RequirementRow(
              label: 'At least 6 characters',
              isMet: password.length >= 6,
            ),
            _RequirementRow(
              label: 'An uppercase letter (A-Z)',
              isMet: RegExp(r'[A-Z]').hasMatch(password),
            ),
            _RequirementRow(
              label: 'A lowercase letter (a-z)',
              isMet: RegExp(r'[a-z]').hasMatch(password),
            ),
            _RequirementRow(
              label: 'A number (0-9)',
              isMet: RegExp(r'[0-9]').hasMatch(password),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String label;
  final bool isMet;

  const _RequirementRow({
    required this.label,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet ? Colors.green.shade400 : Colors.transparent,
              border: Border.all(
                color: isMet
                    ? Colors.green.shade400
                    : Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: isMet
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isMet ? Colors.white : Colors.white54,
              fontSize: 12,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
