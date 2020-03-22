import 'dart:ui';

enum CovidStatus { NO_CONTACT, CONTACT_1, CONTACT_2, POSITIVE, UNKNOWN }

extension CovidStatusExtension on CovidStatus {
  Color toBackgroundColor() {
    switch (this) {
      case CovidStatus.NO_CONTACT:
        return Color(0xFF48BB78);
      case CovidStatus.CONTACT_2:
        return Color(0xFFECC94B);
      case CovidStatus.CONTACT_1:
        return Color(0xFFED8936);
      case CovidStatus.POSITIVE:
        return Color(0xFFF56565);
      case CovidStatus.UNKNOWN:
        return Color(0xFFCBD5E0);
    }
  }

  Color toTextColor() {
    switch (this) {
      case CovidStatus.NO_CONTACT:
        return Color(0xFF2F855A);
      case CovidStatus.CONTACT_2:
        return Color(0xFFB7791F);
      case CovidStatus.CONTACT_1:
        return Color(0xFFC05621);
      case CovidStatus.POSITIVE:
        return Color(0xFFC53030);
      case CovidStatus.UNKNOWN:
        return Color(0xFFCBD5E0);
    }
  }

  String toDispalyText() {
    switch (this) {
      case CovidStatus.NO_CONTACT:
        return 'Kein Kontakt';
      case CovidStatus.CONTACT_2:
        return 'Kontaktperson Stufe II';
      case CovidStatus.CONTACT_1:
        return 'Kontaktperson Stufe I';
      case CovidStatus.POSITIVE:
        return 'COVID19 Positiv';
      case CovidStatus.UNKNOWN:
        return 'Unbekannt';
    }
  }

  String toDatabaseString() => this.toString().split('.').last;
}

CovidStatus covidStatusFromDatabaseString(String databaseString) {
  if (databaseString == 'NO_CONTACT') {
    return CovidStatus.NO_CONTACT;
  }

  if (databaseString == 'CONTACT_2') {
    return CovidStatus.CONTACT_2;
  }
  if (databaseString == 'CONTACT_1') {
    return CovidStatus.CONTACT_1;
  }
  if (databaseString == 'POSITIVE') {
    return CovidStatus.POSITIVE;
  }

  return CovidStatus.UNKNOWN;
}
