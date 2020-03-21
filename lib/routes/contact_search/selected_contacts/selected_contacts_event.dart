part of 'selected_contacts_bloc.dart';

@immutable
@sealed
abstract class SelectedContactsEvent {}

class SelectContactEvent extends SelectedContactsEvent {
  final Contact contact;
  final EncounterType encounterType;
  final Color avatarColor;

  SelectContactEvent(this.contact, this.encounterType, this.avatarColor);
}

class RemoveContactEvent extends SelectedContactsEvent {
  final Contact contact;

  RemoveContactEvent(this.contact);
}

class AddToEncountersEvent extends SelectedContactsEvent {

}
