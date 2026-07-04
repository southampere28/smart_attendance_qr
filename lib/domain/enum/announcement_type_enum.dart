enum AnnouncementTypeEnum {
  classCancelled,
  assignment;

  static AnnouncementTypeEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'class_cancelled':
        return AnnouncementTypeEnum.classCancelled;
      case 'assignment':
        return AnnouncementTypeEnum.assignment;
      default:
        return AnnouncementTypeEnum.classCancelled; // fallback aman
    }
  }

  // title show based on type
  String get title {
    switch (this) {
      case AnnouncementTypeEnum.classCancelled:
        return "Batalkan Kelas";
      case AnnouncementTypeEnum.assignment:
        return "Tugas Baru";
    }
  }

  // to value for sending to backend
  String get value {
    switch (this) {
      case AnnouncementTypeEnum.classCancelled:
        return "class_cancelled";
      case AnnouncementTypeEnum.assignment:
        return "assignment";
    }
  }
  

}
