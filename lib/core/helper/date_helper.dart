class DateHelper {
  static DateTime? parseToLocal(dynamic v) {
      if (v == null) return null;
      try {
        // parse and convert UTC timestamp (with 'Z') correctly to local
        return DateTime.parse(v.toString()).toLocal();
      } catch (e) {
        // fallback to tryParse without throwing
        final parsed = DateTime.tryParse(v.toString());
        return parsed?.toLocal();
      }
    }
}