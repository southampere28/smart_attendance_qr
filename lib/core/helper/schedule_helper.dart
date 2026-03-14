class ScheduleHelper {
  static List<String> dayMapper = [
    'senin',
    'selasa',
    'rabu',
    'kamis',
    'jumat',
    'sabtu',
  ];

  // method for get schedule date day of week
  static List<String> getDatesOfWeek(int countDay) {
    DateTime monday =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

    return List.generate(countDay, (index) {
      return monday
          .add(Duration(days: index))
          .day
          .toString()
          .padLeft(2, '0');
    });
  }

  // method for get month year name of first day in week
  static String getMonthName(int month, int year) {
    const List<String> monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    if (month < 1 || month > 12) {
      throw ArgumentError('Invalid month: $month. Month should be between 1 and 12.');
    }

    final String formattedMonthYear = '${monthNames[month - 1]} $year';

    return formattedMonthYear;
  }

  static String convertTime2Pad(DateTime datetime) {
    // example: 08:00
    return '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
  }

}
