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

  static String convertTime2Pad(DateTime datetime) {
    // example: 08:00
    return '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
  }

}
