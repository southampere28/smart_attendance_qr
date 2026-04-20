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

  static String statusUpcomingAttendance(DateTime timeStart, DateTime timeEnd) {
    final now = DateTime.now();
    if (now.isBefore(timeStart)) {
      return 'Belum Dimulai';
    } else if (now.isAfter(timeEnd)) {
      return 'Sudah Selesai';
    } else {
      return 'Sedang Berlangsung';
    }
  }

  static String countDownTimer(DateTime timeEnd, {DateTime? customNow}) {
    final now = customNow ?? DateTime.now();

    /// time in menit, jam, hari
    final difference = timeEnd.difference(now);
    if (difference.inSeconds <= 0) {
      return 'Waktu Habis';
    } else if (difference.inMinutes < 1) {
      return '${difference.inSeconds} detik lagi';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lagi';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam lagi';
    } else {
      return '${difference.inDays} hari lagi';
    }
  }
}
