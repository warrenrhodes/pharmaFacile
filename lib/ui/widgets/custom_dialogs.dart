import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CustomDialogs {
  /// Show a ShadAlertDialog for alerts
  static Future<void> showAlertDialog(
      BuildContext context, String title, String content) async {
    await showDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: Text(title),
        actions: [
          ShadButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
        child: Text(content),
      ),
    );
  }

  /// Show a ShadAlertDialog for confirmation
  static Future<bool> showConfirmDialog(
      BuildContext context, String title, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: Text(title),
        actions: [
          ShadButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ShadButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmer'),
          ),
        ],
        child: Text(content),
      ),
    );
    return result ?? false;
  }
}
