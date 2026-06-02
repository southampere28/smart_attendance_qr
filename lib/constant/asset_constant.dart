class AssetConstant {
  // base path icon
  static const String baseImagePath = 'assets/images';
  static const String baseIconPath = 'assets/icons';

  // icon core general
  static const String iconApp = '$baseIconPath/icon_app.png';
  static const String iconAppSVG = '$baseIconPath/icon_app.svg';
  static const String iconDailyAttendance = '$baseIconPath/ic-attendance-daily.svg';

  /// icon per feature here...
  static const String svgIconQR = '$baseIconPath/qr_code_scanner.svg';
  static const String svgIconSubject = '$baseIconPath/icon_subject.svg';
  static const String svgIconSubjectThin =
      '$baseIconPath/icon_subject_thin.svg';
  
  // image core general
  static const String imageExamplePermission = '$baseImagePath/example_permission.png';

  // attendance status icons
  static const String iconAttValid = '$baseIconPath/ic-attendance-valid.svg';
  static const String iconAttNone = '$baseIconPath/ic-attendance-none.svg';

  // notif or permission icons
  static const String iconDefaultNotif = '$baseIconPath/ic-notif-default.png';
  static const String iconAssignment = '$baseIconPath/ic-notif-assignment.png';
  static const String iconPermission = '$baseIconPath/ic-notif-permission.png';
  static const String iconPermissionAcc = '$baseIconPath/ic-notif-permit-acc.png';
  static const String iconPermissionRej = '$baseIconPath/ic-notif-permit-rej.png';

  static String getPermissionIconStatus(String type) {
    switch (type) {
      case 'proses':
        return iconPermission;
      case 'diterima':
        return iconPermissionAcc;
      case 'ditolak':
        return iconPermissionRej;
      default:
        return iconPermission; // fallback.
    }
  }

  static String getNotificationIconByType(String type) {
    switch (type) {
      case 'assignment':
        return iconAssignment;
      case 'permission':
        return iconPermission;
      case "permission_accepted":
        return iconPermissionAcc;
      case "permission_rejected":
        return iconPermissionRej;
      default:
        return iconDefaultNotif; // fallback
    }
  }

}
