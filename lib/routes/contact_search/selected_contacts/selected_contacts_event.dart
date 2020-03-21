part of 'selected_contacts_bloc.dart';

@immutable
@sealed
abstract class SelectedContactsEvent {}

class SelectContactEvent extends SelectedContactsEvent {
  final Contact contact;
  final ContactType contactType;
  final Color avatarColor;

  SelectContactEvent(this.contact, this.contactType, this.avatarColor);
}

class RemoveContactEvent extends SelectedContactsEvent {
  final Contact contact;

  RemoveContactEvent(this.contact);
}
