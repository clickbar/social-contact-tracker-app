import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';

class SelectedContact {
  final Contact contact;
  final EncounterType encounterType;
  final Color avatarColor;

  SelectedContact(this.contact, this.encounterType, this.avatarColor);
}