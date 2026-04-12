enum AttendanceDailyStatusEnum {
  ontime,
  late,
  none;

  static AttendanceDailyStatusEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'tepat_waktu':
      case 'ontime':
        return AttendanceDailyStatusEnum.ontime;
      case 'terlambat':
      case 'late':
        return AttendanceDailyStatusEnum.late;
      default:
        return AttendanceDailyStatusEnum.none; // fallback aman
    }
  }

  static String toStringValue(AttendanceDailyStatusEnum status) {
    switch (status) {
      case AttendanceDailyStatusEnum.ontime:
        return 'tepat_waktu';
      case AttendanceDailyStatusEnum.late:
        return 'terlambat';
      case AttendanceDailyStatusEnum.none:
        return 'none'; // or null if you prefer to return null
    }
  }

  static String toTitle(AttendanceDailyStatusEnum status) {
    switch (status) {
      case AttendanceDailyStatusEnum.ontime:
        return 'Hadir';
      case AttendanceDailyStatusEnum.late:
        return 'Terlambat';
      case AttendanceDailyStatusEnum.none:
        return 'Unknown';
    }
  }
}

extension AttendanceDailyStatusEnumX on AttendanceDailyStatusEnum {
  String get dbValue => AttendanceDailyStatusEnum.toStringValue(this);

  String get title => AttendanceDailyStatusEnum.toTitle(this);

  bool get isOnTime => this == AttendanceDailyStatusEnum.ontime;

  bool get isLate => this == AttendanceDailyStatusEnum.late;

  bool get isNone => this == AttendanceDailyStatusEnum.none;
}
