class DateHelper {
  static DateTime? parseToLocal(dynamic v) {
    if (v == null) return null;
    try {
      // parse and convert UTC timestamp (with 'Z') correctly to local
      return DateTime.parse(v.toString()).toLocal();
    } catch (e) {
      // fallback to tryParse without throwing
      final parsed = DateTime.tryParse(v.toString());
      return parsed?.toLocal();
    }
  }

  // parse to local non nullable,
  static DateTime parseToLocalNonNullable(dynamic v) {
    final parsed = parseToLocal(v);
    if (parsed == null) {
      // return current local time if parsing fails
      return DateTime.now();
    }
    return parsed;
  }

  static String formatToWIBTime(DateTime date) {
    // format time to indonesian (06:20 WIB)
    final indonesianHour = date.hour.toString().padLeft(2, '0');
    final indonesianMinute = date.minute.toString().padLeft(2, '0');
    return '$indonesianHour:$indonesianMinute WIB';
  }
}
