enum PermissionTypeEnum {
  sakit,
  izin,
  dispen;

  static PermissionTypeEnum fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sakit':
      case 'sick':
        return PermissionTypeEnum.sakit;

      case 'izin':
        return PermissionTypeEnum.izin;

      case 'dispen':
        return PermissionTypeEnum.dispen;

      default:
        return PermissionTypeEnum.izin; // fallback aman
    }
  }
}
