enum DisrepancyTypeEnum {
  terlambat,
  hp_tidak_tersedia,
  izin,
  pulang_awal,
  alasan_lain,
  unknown;

  static DisrepancyTypeEnum fromString(String? value) {
    if (value == null) return DisrepancyTypeEnum.unknown;
    switch (value) {
      case 'terlambat':
        return DisrepancyTypeEnum.terlambat;
      case 'hp_tidak_tersedia':
        return DisrepancyTypeEnum.hp_tidak_tersedia;
      case 'izin':
        return DisrepancyTypeEnum.izin;
      case 'pulang_awal':
        return DisrepancyTypeEnum.pulang_awal;
      case 'alasan_lain':
        return DisrepancyTypeEnum.alasan_lain;
      default:
        return DisrepancyTypeEnum.unknown;
    }
  }
}

extension DisrepancyTypeExtension on DisrepancyTypeEnum {
  String get name {
    switch (this) {
      case DisrepancyTypeEnum.terlambat:
        return 'terlambat';
      case DisrepancyTypeEnum.hp_tidak_tersedia:
        return 'hp_tidak_tersedia';
      case DisrepancyTypeEnum.izin:
        return 'izin';
      case DisrepancyTypeEnum.pulang_awal:
        return 'pulang_awal';
      case DisrepancyTypeEnum.alasan_lain:
        return 'alasan_lain';
      default:
        return 'unknown';
    }
  }
}
