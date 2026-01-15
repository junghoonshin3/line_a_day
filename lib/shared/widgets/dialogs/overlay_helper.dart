import 'package:flutter/material.dart';
import 'app_dialog.dart';
import 'app_bottom_sheet.dart';

class OverlayHelper {
  static Future<T?> showDialog<T>(
    BuildContext context, {
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool dismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        return Center(
          child: AppDialog(title: title, content: content, actions: actions),
        );
      },
    );
  }

  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    String? title,
    required Widget content,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AppBottomSheet(title: title, child: content),
    );
  }
}
