import 'package:flutter/material.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/utils/validators.dart';


class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = Validators.getPasswordStrength(password);
    final requirements = Validators.getPasswordRequirements(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bar
        if (password.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _getStrengthValue(strength),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStrengthColor(strength, context),
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              horizontalSpace(12),
              Text(
                _getStrengthText(strength),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStrengthColor(strength, context),
                ),
              ),
            ],
          ),
          verticalSpace(12),
        ],

        // Requirements
        Text(
          'Password must contain:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        verticalSpace(8),
        _buildRequirement(
          context,
          'At least 8 characters',
          requirements['minLength']!,
        ),
        _buildRequirement(
          context,
          'One uppercase letter (A-Z)',
          requirements['hasUppercase']!,
        ),
        _buildRequirement(
          context,
          'One lowercase letter (a-z)',
          requirements['hasLowercase']!,
        ),
        _buildRequirement(
          context,
          'One number (0-9)',
          requirements['hasNumber']!,
        ),
        _buildRequirement(
          context,
          'One special character (!@#\$%...)',
          requirements['hasSpecialChar']!,
        ),
      ],
    );
  }

  Widget _buildRequirement(BuildContext context, String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          horizontalSpace(8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              decoration: isMet ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  double _getStrengthValue(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return 0.0;
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  Color _getStrengthColor(PasswordStrength strength, BuildContext context) {
    switch (strength) {
      case PasswordStrength.empty:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
      case PasswordStrength.weak:
        return Theme.of(context).colorScheme.error;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }
}
