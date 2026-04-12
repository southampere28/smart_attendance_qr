enum AttendanceStatusEnum {
  valid,
  invalid,
  sick,
  permission,
  dispensation,
  alpha,
  none; // added a none status (jika belum ada status / data kosong)

  static AttendanceStatusEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'valid':
      case 'present':
      case 'hadir':
        return AttendanceStatusEnum.valid;
      
      case 'none':
      case 'null':
        return AttendanceStatusEnum.none;

      case 'invalid':
        return AttendanceStatusEnum.invalid;

      case 'sick':
      case 'sakit':
        return AttendanceStatusEnum.sick;

      case 'permission':
      case 'excused':
      case 'izin':
        return AttendanceStatusEnum.permission;

      case 'dispensation':
      case 'dispensasi':
      case 'dispen':
        return AttendanceStatusEnum.dispensation;

      case 'alpha':
        return AttendanceStatusEnum.alpha;

      default:
        return AttendanceStatusEnum.none; // fallback aman
    }
  }
}
