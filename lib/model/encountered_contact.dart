import 'dart:ui';

import 'package:random_color/random_color.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';

class EncounteredContact {
  final String contactIdentifier;
  final String initials;
  final String picturePath;
  final Color avatarColor;
  final String displayName;
  final EncounterType encounterType;
  final CovidStatus covidStatus;
  final DateTime covidStatusUpdatedAt;

  bool get hasImage => picturePath != null;

  EncounteredContact(
      this.contactIdentifier,
      this.initials,
      this.picturePath,
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
      'AA',
      null,
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Alexander Agasiev',
      EncounterType.DIRECT,
      CovidStatus.NO_CONTACT,
      DateTime.now()),
  EncounteredContact(
      '3037',
      'PP',
      null,
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Peter Pan',
      EncounterType.TWO_METERS,
      CovidStatus.NO_CONTACT,
      DateTime.now()),
  EncounteredContact(
      '3037',
      'IN',
      null,
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Idris Nematpur',
      EncounterType.DIRECT,
      CovidStatus.NO_CONTACT,
      DateTime.now()),
  DateTime.now().add(Duration(days: -1)),
  EncounteredContact(
      '3037',
      'AK',
      null,
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Alexsander Küchler',
      EncounterType.SAME_ROOM,
      CovidStatus.NO_CONTACT,
      DateTime.now()),
  EncounteredContact(
      '3037',
      'PP',
      null,
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Peter Pan',
      EncounterType.TWO_METERS,
      CovidStatus.NO_CONTACT,
      DateTime.now()),
  DateTime.now().add(Duration(days: -2)),
  EncounteredContact(
      '3037',
      'AA',
      null,
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Alexander Agasiev',
      EncounterType.SAME_ROOM,
      CovidStatus.NO_CONTACT,
      DateTime.now()),
  EncounteredContact(
      '3037',
      'IN',
      null,
      randomColor.randomColor(colorHue: ColorHue.blue),
      'Idris Nematpur',
      EncounterType.DIRECT,
      CovidStatus.NO_CONTACT,
      DateTime.now()),
];
