import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.borderColor,
    this.textColor,
    this.isLoading = false,
    this.isOutlined = false,
  });

  final void Function()? onPressed;
  final String text;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final bool isLoading;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final effectiveButtonColor =
        buttonColor ??
            (isOutlined
                ? Colors.transparent
                : Theme.of(context).colorScheme.primary);
    final effectiveBorderColor =
        borderColor ?? Theme.of(context).colorScheme.primary;
    final effectiveTextColor =
        textColor ??
            (isOutlined
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveButtonColor,
          foregroundColor: effectiveTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isOutlined ? 0 : 2,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          side: BorderSide(
            color: effectiveBorderColor,
            width: isOutlined ? 2 : 0,
          ),
          disabledBackgroundColor: Theme.of(context).colorScheme.surface,
          disabledForegroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withOpacity(0.38),
        ),
        child: isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              isOutlined
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        )
            : Text(
          text,
          style: TextStyle(
            color: effectiveTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}