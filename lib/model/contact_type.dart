import 'package:flutter/cupertino.dart';

enum ContactType { DIRECT, SAME_ROOM, TWO_METERS }

extension ContactTypeExtensions on ContactType {
  String toDisplayString() {
    switch (this) {
      case ContactType.DIRECT:
        return 'Direkter Kontakt';
      case ContactType.SAME_ROOM:
        return 'Selber Raum';
      case ContactType.TWO_METERS:
        return '2m Abstand';
    }
  }

  Color toBadgeBackgroundColor() {
    switch (this) {
      case ContactType.DIRECT:
        return Color(0xFFFBECDE);
      case ContactType.SAME_ROOM:
        return Color(0xFFFCF5BA);
      case ContactType.TWO_METERS:
        return Color(0xFFE3F6ED);
    }
  }

  Color toBadgeTextColorColor() {
    switch (this) {
      case ContactType.DIRECT:
        return Color(0xFF803219);
      case ContactType.SAME_ROOM:
        return Color(0xFF6B3D1D);
      case ContactType.TWO_METERS:
        return Color(0xFF225240);
    }
  }
}
