import 'dart:ui';

import 'package:random_color/random_color.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';

class EncounteredContact {
  final String contactIdentifier;
  final bool hasImage;
  final String initials;
  final Color avatarColor;
  final String displayName;
  final EncounterType encounterType;
  final CovidStatus covidStatus;
  final DateTime covidStatusUpdatedAt;

  EncounteredContact(
      this.contactIdentifier,
      this.hasImage,
      this.initials,
      this.avatarColor,
      this.displayName,
      this.encounterType,
      this.covidStatus,
      this.covidStatusUpdatedAt);
}

final RandomColor randomColor = RandomColor();

final kDemoEncounteredContacts = [
  DateTime.now(),
  EncounteredContact(
      '3037',
      true,
      'AA',
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Alexander Agasiev',
      EncounterType.DIRECT,
      CovidStatus.HEALTHY,
      DateTime.now()),
  EncounteredContact(
      '3037',
      false,
      'PP',
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Peter Pan',
      EncounterType.TWO_METERS,
      CovidStatus.HEALTHY,
      DateTime.now()),
  EncounteredContact(
      '3037',
      false,
      'IN',
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Idris Nematpur',
      EncounterType.DIRECT,
      CovidStatus.HEALTHY,
      DateTime.now()),
  DateTime.now().add(Duration(days: -1)),
  EncounteredContact(
      '3037',
      false,
      'AK',
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Alexsander Küchler',
      EncounterType.SAME_ROOM,
      CovidStatus.HEALTHY,
      DateTime.now()),
  EncounteredContact(
      '3037',
      false,
      'PP',
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Peter Pan',
      EncounterType.TWO_METERS,
      CovidStatus.HEALTHY,
      DateTime.now()),
  DateTime.now().add(Duration(days: -2)),
  EncounteredContact(
      '3037',
      true,
      'AA',
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Alexander Agasiev',
      EncounterType.SAME_ROOM,
      CovidStatus.HEALTHY,
      DateTime.now()),
  EncounteredContact(
      '3037',
      false,
      'IN',
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Idris Nematpur',
      EncounterType.DIRECT,
      CovidStatus.HEALTHY,
      DateTime.now()),
];
