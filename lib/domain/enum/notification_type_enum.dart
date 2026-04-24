enum NotificationTypeEnum {
  announcementAcademic,
  announcementGeneral,
  lostAndFound,
  emergencyInfo,
  classCancelled,
  announcementForClass,
  assignment,
  permission,
  attendanceViolation,
  personalNote,
  none;

  static NotificationTypeEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'announcement_academic':
        return NotificationTypeEnum.announcementAcademic;
      case 'announcement_general':
        return NotificationTypeEnum.announcementGeneral;
      case 'lost_and_found':
        return NotificationTypeEnum.lostAndFound;
      case 'emergency_info':
        return NotificationTypeEnum.emergencyInfo;
      case 'class_cancelled':
        return NotificationTypeEnum.classCancelled;
      case 'class_notification':
        return NotificationTypeEnum.announcementForClass;
      case 'assignment':
        return NotificationTypeEnum.assignment;
      case 'permission':
        return NotificationTypeEnum.permission;
      case 'attendance_violation':
        return NotificationTypeEnum.attendanceViolation;
      case 'personal_note':
        return NotificationTypeEnum.personalNote;
      default:
        return NotificationTypeEnum.none; // fallback aman
    }
  }

  static String toStringValue(NotificationTypeEnum value) {
    switch (value) {
      case NotificationTypeEnum.announcementAcademic:
        return 'announcement_academic';
      case NotificationTypeEnum.announcementGeneral:
        return 'announcement_general';
      case NotificationTypeEnum.lostAndFound:
        return 'lost_and_found';
      case NotificationTypeEnum.emergencyInfo:
        return 'emergency_info';
      case NotificationTypeEnum.classCancelled:
        return 'class_cancelled';
      case NotificationTypeEnum.announcementForClass:
        return 'class_notification';
      case NotificationTypeEnum.assignment:
        return 'assignment';
      case NotificationTypeEnum.permission:
        return 'permission';
      case NotificationTypeEnum.attendanceViolation:
        return 'attendance_violation';
      case NotificationTypeEnum.personalNote:
        return 'personal_note';
      case NotificationTypeEnum.none:
        return 'none';
    }
  }
}

extension NotificationTypeEnumX on NotificationTypeEnum {
  String get dbValue => NotificationTypeEnum.toStringValue(this);

  String get title {
    switch (this) {
      case NotificationTypeEnum.announcementAcademic:
        return 'Pengumuman Akademik';
      case NotificationTypeEnum.announcementGeneral:
        return 'Pengumuman Umum';
      case NotificationTypeEnum.lostAndFound:
        return 'Barang Hilang & Temuan';
      case NotificationTypeEnum.emergencyInfo:
        return 'Info Darurat';
      case NotificationTypeEnum.classCancelled:
        return 'Kelas Dibatalkan';
      case NotificationTypeEnum.announcementForClass:
        return 'Pengumuman Kelas';
      case NotificationTypeEnum.assignment:
        return 'Tugas';
      case NotificationTypeEnum.permission:
        return 'Perizinan';
      case NotificationTypeEnum.attendanceViolation:
        return 'Pelanggaran Kehadiran';
      case NotificationTypeEnum.personalNote:
        return 'Catatan Pribadi';
      case NotificationTypeEnum.none:
        return 'Unknown';
    }
  }
}
