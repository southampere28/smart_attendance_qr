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
}
