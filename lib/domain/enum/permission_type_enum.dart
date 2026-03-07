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

}
