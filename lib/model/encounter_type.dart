import 'package:flutter/cupertino.dart';

enum EncounterType { DIRECT, SAME_ROOM, TWO_METERS }

extension EncounterTypeExtensions on EncounterType {
  String toDisplayString() {
    switch (this) {
      case EncounterType.DIRECT:
        return 'Direkter Kontakt';
      case EncounterType.SAME_ROOM:
        return 'Selber Raum';
      case EncounterType.TWO_METERS:
        return '2m Abstand';
    }
  }

  Color toBadgeBackgroundColor() {
    switch (this) {
      case EncounterType.DIRECT:
        return Color(0xFFFBECDE);
      case EncounterType.SAME_ROOM:
        return Color(0xFFFCF5BA);
      case EncounterType.TWO_METERS:
        return Color(0xFFE3F6ED);
    }
  }

  Color toBadgeTextColorColor() {
    switch (this) {
      case EncounterType.DIRECT:
        return Color(0xFF803219);
      case EncounterType.SAME_ROOM:
        return Color(0xFF6B3D1D);
      case EncounterType.TWO_METERS:
        return Color(0xFF225240);
    }
  }
}
