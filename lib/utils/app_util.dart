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
    showDialog(
      context: context,
      barrierDismissible: false, // tidak bisa ditutup dengan tap di luar
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
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
