import 'dart:ui';

enum CovidStatus { HEALTHY, CONTACT_1, CONTACT_2, POSITIVE, UNKNOWN }

extension CovidStatusExtension on CovidStatus {
  Color toBackgroundColor() {
    switch (this) {
      case CovidStatus.HEALTHY:
        return Color(0xFF48BB78);
      case CovidStatus.CONTACT_1:
        return Color(0xFFECC94B);
      case CovidStatus.CONTACT_2:
        return Color(0xFFED8936);
      case CovidStatus.POSITIVE:
        return Color(0xFFF56565);
      case CovidStatus.UNKNOWN:
        return Color(0xFFCBD5E0);
    }
  }
}
