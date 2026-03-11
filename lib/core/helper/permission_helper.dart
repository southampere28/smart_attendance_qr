import 'package:intl/intl.dart';

class PermissionHelper {
  static String formatDisplayPermissionInfo(
      String reason, int countOfDay, DateTime datePermission, int countOfDays) {
    // to (12-15 Sep 2025)
    final start = datePermission;
    final end = datePermission
        .add(Duration(days: (countOfDays > 0 ? countOfDays - 1 : 0)));

    String dateRange;
    if (countOfDays <= 1) {
      dateRange = DateFormat('dd MMM yyyy').format(start);
    } else {
      if (start.year == end.year) {
        if (start.month == end.month) {
          // Same month/year: "12 - 15 Sep 2025"
          dateRange =
              '${DateFormat('dd').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}';
        } else {
          // Different months but same year: "28 Feb - 02 Mar 2025"
          dateRange =
              '${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}';
        }
      } else {
        // Different years: show full dates for both
        dateRange =
            '${DateFormat('dd MMM yyyy').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}';
      }
    }

    return '$reason • $countOfDay hari ($dateRange)';
  }
}
