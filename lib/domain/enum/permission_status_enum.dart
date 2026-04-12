enum PermissionStatusEnum {
  proses,
  diterima,
  ditolak,
  none;

  static PermissionStatusEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'proses':
        return PermissionStatusEnum.proses;

      case 'diterima':
        return PermissionStatusEnum.diterima;

      case 'ditolak':
        return PermissionStatusEnum.ditolak;

      default:
        return PermissionStatusEnum.none; // fallback aman
    }
  }

  static String toStringValue(PermissionStatusEnum value) {
    switch (value) {
      case PermissionStatusEnum.proses:
        return 'proses';
      case PermissionStatusEnum.diterima:
        return 'diterima';
      case PermissionStatusEnum.ditolak:
        return 'ditolak';
      case PermissionStatusEnum.none:
        return 'none';
    }
  }
}

extension PermissionStatusEnumX on PermissionStatusEnum {
  String get dbValue => PermissionStatusEnum.toStringValue(this);

  String get title {
    switch (this) {
      case PermissionStatusEnum.proses:
        return 'Proses';
      case PermissionStatusEnum.diterima:
        return 'Diterima';
      case PermissionStatusEnum.ditolak:
        return 'Ditolak';
      case PermissionStatusEnum.none:
        return 'Unknown';
    }
  }
}
