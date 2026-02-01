enum AttendanceStatusEnum {
  valid,
  invalid,
  sick,
  permission,
  dispensation,
  none; // added a none status (jika belum ada status / data kosong)

  static AttendanceStatusEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'valid':
      case 'present':
        return AttendanceStatusEnum.valid;
      
      case 'none':
        return AttendanceStatusEnum.none;

      case 'invalid':
      case 'absent':
        return AttendanceStatusEnum.invalid;

      case 'sick':
        return AttendanceStatusEnum.sick;

      case 'permission':
      case 'excused':
        return AttendanceStatusEnum.permission;

      case 'dispensation':
        return AttendanceStatusEnum.dispensation;

      default:
        return AttendanceStatusEnum.none; // fallback aman
    }
  }
}
