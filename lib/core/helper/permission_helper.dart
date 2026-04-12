import 'package:intl/intl.dart';

class PermissionHelper {
  static String formatDisplayPermissionInfo(DateTime datePermission) {
    // to: senin, 10 April 2023
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    return dateFormat.format(datePermission);
  }

  static String formattedPreviewPermissionInfo(
      {required int dayCount, required String reason}) {
    // to: Izin * 3 hari.
    return "$reason \u2022 $dayCount hari";
  }
}
