import 'package:absensi_qr/feature_student/permission/presentation/widgets/dialog_permission_detail_student.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/widgets/dialog_permission_detail.dart';
import 'package:absensi_qr/models/model_merging/permission_student_item.dart';
import 'package:absensi_qr/models/permission_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// place all helper function in this class
class AppUtil {
  static String formatDate(DateTime date) {
    final formatter = DateFormat('MM dd yyyy');
    return formatter.format(date);
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
    });
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    if (!_isLoadingDialogVisible) return;
    try {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (_) {
      // ignore errors when popping fails
    } finally {
      _isLoadingDialogVisible = false;
    }
  }

  static bool _isLoadingDialogVisible = false;

  /// Dialog detail perizinan siswa.
  /// [widthFactor] mengatur lebar dialog relatif terhadap lebar layar (default 0.88 = 88%).
  /// Tombol Tolak/Setuju hanya muncul saat status perizinan masih "proses".
  static void showPermissionDetailDialog(
    BuildContext context, {
    required PermissionStudentItem permissionData,
    required VoidCallback onAccept,
    required VoidCallback onReject,
    double widthFactor = 0.92,
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
}
