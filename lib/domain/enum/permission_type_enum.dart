enum PermissionTypeEnum {
  sakit,
  izin,
  dispen,
  lainnya;

  static PermissionTypeEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sick':
      case 'sakit':
        return PermissionTypeEnum.sakit;

      case 'excused':
      case 'izin':
        return PermissionTypeEnum.izin;

      case 'dispen':
        return PermissionTypeEnum.dispen;

      case 'etc':
      case 'lainnya':
        return PermissionTypeEnum.lainnya;

      default:
        return PermissionTypeEnum.izin; // fallback aman
    }
  }

  static String toStringValue(PermissionTypeEnum value) {
    switch (value) {
      case PermissionTypeEnum.sakit:
        return 'sakit';
      case PermissionTypeEnum.izin:
        return 'izin';
      case PermissionTypeEnum.dispen:
        return 'dispen';
      case PermissionTypeEnum.lainnya:
        return 'lainnya';
    }
  }

  static String toTitle(PermissionTypeEnum value) {
    switch (value) {
      case PermissionTypeEnum.sakit:
        return 'Sakit';
      case PermissionTypeEnum.izin:
        return 'Izin';
      case PermissionTypeEnum.dispen:
        return 'Dispen';
      case PermissionTypeEnum.lainnya:
        return 'Lainnya';
    }
  }
}

extension PermissionTypeEnumX on PermissionTypeEnum {
  String get dbValue => PermissionTypeEnum.toStringValue(this);
  String get title => PermissionTypeEnum.toTitle(this);
}
