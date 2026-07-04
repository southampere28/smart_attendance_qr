import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:absensi_qr/constant/app_color.dart';

/// Safe snackbar utility using ScaffoldMessenger instead of GetX snackbar queue.
///
/// Avoids GetX `SnackbarController` `LateInitializationError` and prevents
/// `Get.back()` from being permanently wedged.
class AppSnackbar {
  /// Drop-in replacement for GetX's `Get.snackbar(...)`.
  static void snackbar(
    String title,
    String message, {
    Color? colorText,
    Color? backgroundColor,
    Duration? duration,
    Widget? icon,
  }) {
    final textColor = colorText ?? Colors.white;
    _show(
      title,
      message,
      backgroundColor: backgroundColor ?? AppColor.primaryColor,
      textColor: textColor,
      icon: icon ?? Icon(Icons.info_outline, color: textColor),
      duration: duration,
    );
  }

  /// Show success snackbar
  static void showSuccess(
    String title,
    String message, {
    Duration? duration,
  }) {
    _show(
      title,
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: duration,
    );
  }

  /// Show error snackbar
  static void showError(
    String title,
    String message, {
    Duration? duration,
  }) {
    _show(
      title,
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: duration,
    );
  }

  /// Show warning snackbar
  static void showWarning(
    String title,
    String message, {
    Duration? duration,
  }) {
    _show(
      title,
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: duration,
    );
  }

  /// Show info snackbar
  static void showInfo(
    String title,
    String message, {
    Duration? duration,
  }) {
    _show(
      title,
      message,
      backgroundColor: AppColor.primaryColor,
      textColor: Colors.white,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      duration: duration,
    );
  }

  /// Dismiss current snackbar
  static void closeCurrent() {
    _resolveMessenger()?.removeCurrentSnackBar();
  }

  /// Dismiss all snackbars
  static void closeAll() {
    _resolveMessenger()?.clearSnackBars();
  }

  /// Internal method to resolve ScaffoldMessengerState
  static ScaffoldMessengerState? _resolveMessenger() {
    final contexts = [
      Get.overlayContext,
      Get.context,
      Get.key.currentContext,
    ];

    for (final context in contexts) {
      if (context == null || !context.mounted) {
        continue;
      }
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger != null) {
        return messenger;
      }
    }
    return null;
  }

  /// Internal method to show snackbar
  static void _show(
    String title,
    String message, {
    required Color backgroundColor,
    required Color textColor,
    required Widget icon,
    Duration? duration,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messenger = _resolveMessenger();
      if (messenger == null) {
        return;
      }

      messenger.removeCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          margin: const EdgeInsets.all(16),
          duration: duration ?? const Duration(milliseconds: 2000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Row(
            children: [
              icon,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (message.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
