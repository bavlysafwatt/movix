import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movix/core/widgets/custom_alert_dialog.dart';

class Messages {
  static void showErrorDialog({
    required BuildContext context,
    required String dialogHeader,
    required String dialogBody,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        dialogIcon: FontAwesomeIcons.circleExclamation,
        dialogHeader: dialogHeader,
        dialogBody: dialogBody,
        dialogColor: Theme.of(context).colorScheme.error,
        press: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  static void showSuccessDialog({
    required BuildContext context,
    required String dialogHeader,
    required String dialogBody,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        dialogIcon: FontAwesomeIcons.circleCheck,
        dialogHeader: dialogHeader,
        dialogBody: dialogBody,
        dialogColor: Theme.of(context).colorScheme.primary,
        press: () {
          Navigator.of(context).pop();
          onPressed?.call();
        },
      ),
    );
  }

  static void showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.none,
        content: Text(message, style: TextStyle(color: textColor)),
      ),
    );
  }

  static void showSuccessSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showErrorSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showInfoSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.black,),),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSnackBarWithAction({
    required BuildContext context,
    required String message,
    required String actionLabel,
    required VoidCallback onActionPressed,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: actionLabel,
          textColor: Colors.white,
          onPressed: onActionPressed,
        ),
      ),
    );
  }
}
