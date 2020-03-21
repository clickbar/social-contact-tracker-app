import 'package:flutter/cupertino.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';

class Encounter {
  final String contactIdentifier;
  final String contactInitials;
  final String picturePath;
  final Color avatarColor;
  final String contactDisplayName;
  final EncounterType encounterType;
  final DateTime encounteredAt;

  Encounter(
      this.contactIdentifier,
      this.contactInitials,
      this.picturePath,
      this.avatarColor,
      this.contactDisplayName,
      this.encounterType,
      this.encounteredAt);

  factory Encounter.fromDatabase(Map<String, dynamic> data) {
    return Encounter(
      data['contact_identifier'],
      data['contact_initials'],
      data['contact_picture_path'],
      Color(data['contact_avatar_color']),
      data['contact_display_name'],
      encounterTypeFromDatabaseString(data['contact_encounter_type']),
      DateTime.fromMillisecondsSinceEpoch(data['encountered_at']),
    );
  }
}
