import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/model/encounter_type.dart';

class SelectedContact {
  final Contact contact;
  final EncounterType encounterType;

  SelectedContact(this.contact, this.encounterType);
}
