import 'package:absensi_qr/app_routes.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/domain/enum/notification_type_enum.dart';
import 'package:absensi_qr/feature_student/permission/presentation/widgets/dialog_permission_detail_student.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/widgets/dialog_permission_detail.dart';
import 'package:absensi_qr/models/model_merging/permission_student_item.dart';
import 'package:absensi_qr/models/permission_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// place all helper function in this class
class AppUtil {
  static String formatDate(DateTime date) {
    final formatter = DateFormat('MM dd yyyy');
    return formatter.format(date);
  }

  static String formatTime(DateTime time) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(time);
  }

  static String formatDateIndonesia(DateTime date) {
    // ex: senin, 16 agustus 2023
    final formatter = DateFormat.yMMMMEEEEd('id_ID');
    return formatter.format(date);
  }

  bool isEmailValid(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  static void showLoadingDialog(BuildContext context, {String? message}) {
    if (_isLoadingDialogVisible) return;
    _isLoadingDialogVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false, // tidak bisa ditutup dengan tap di luar
      useRootNavigator: true,
      builder: (context) {
        // capture the dialog's own BuildContext so we can pop using it
        _loadingDialogContext = context;
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Flexible(child: Text(message ?? "Loading...")),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _isLoadingDialogVisible = false;
      _loadingDialogContext = null;
    });
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    if (!_isLoadingDialogVisible) return;
    try {
      // prefer popping using the dialog's own context
      if (_loadingDialogContext != null) {
        final dialogCtx = _loadingDialogContext!;
        if (Navigator.of(dialogCtx).canPop()) {
          Navigator.of(dialogCtx).pop();
        }
      } else {
        // fallback to popping using provided context (root navigator)
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    } catch (_) {
      // ignore errors when popping fails
    } finally {
      _isLoadingDialogVisible = false;
      _loadingDialogContext = null;
    }
  }
  static BuildContext? _loadingDialogContext;

  static bool _isLoadingDialogVisible = false;

  /// Dialog detail perizinan siswa.
  /// [widthFactor] mengatur lebar dialog relatif terhadap lebar layar (default 0.88 = 88%).
  /// Tombol Tolak/Setuju hanya muncul saat status perizinan masih "proses".
  static void showPermissionDetailDialog(
    BuildContext context, {
    required PermissionStudentItem permissionData,
    required VoidCallback onAccept,
    required VoidCallback onReject,
    double widthFactor = 0.90,
  }) {
    showDialog(
      context: context,
      builder: (_) => DialogPermissionDetail(
        permissionData: permissionData,
        onAccept: onAccept,
        onReject: onReject,
        widthFactor: widthFactor,
      ),
    );
  }

  static void showPermissionDetailDialogStudent(
    BuildContext context, {
    required String studentName,
    required PermissionModel permissionData,
    required VoidCallback onTap,
    double widthFactor = 0.9,
  }) {
    showDialog(
      context: context,
      builder: (_) => DialogPermissionDetailStudent(
        permissionData: permissionData,
        studentName: studentName,
        onTap: onTap,
        widthFactor: widthFactor,
      ),
    );
  }

  // helper form validation
  static String? validateEmail(String? value) {
    // value null or empty
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    // validate email format (simple regex), should contain "@" and "."
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // snackbar error
  static void showGetSnackBar(String title, String message,
      {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
    );
  }
}
